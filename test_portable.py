"""Exercise packaged runtime and prepare TS without opening an RF stream."""
from pathlib import Path
import os,subprocess,tempfile,sys,json
r=Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Path(__file__).parent/'ONE SEG Studio.app/Contents/Resources'
r=r.resolve();rt=r/'Runtime'
with tempfile.TemporaryDirectory(prefix='oneseg-portable-') as tmp:
 e={'HOME':tmp,'PATH':str(rt/'bin')+':/usr/bin:/bin','PYTHONHOME':str(rt/'python'),'PYTHONNOUSERSITE':'1','PYTHONDONTWRITEBYTECODE':'1','SOAPY_SDR_ROOT':str(rt),'SOAPY_SDR_PLUGIN_PATH':str(rt/'modules'),'ONESEG_DATA':tmp,'DYLD_PRINT_LIBRARIES':'1'}
 def run(args):
  p=subprocess.run([str(x) for x in args],env=e,capture_output=True,text=True)
  external=[l for l in p.stderr.splitlines() if l.startswith('dyld[') and ('/opt/homebrew/' in l or '/Users/klima/' in l and str(r) not in l)]
  assert not external,external
  if p.returncode: raise RuntimeError(p.stdout+'\n'+p.stderr[-5000:])
  return p.stdout
 print(run([rt/'bin/python3','-c','from gnuradio import gr,blocks,digital,dtv,fft,filter,soapy; import gnuradio.isdbt; import numpy; print("GNU Radio + ISDB-T + NumPy: OK")']))
 info=run([rt/'bin/SoapySDRUtil','--info']);assert 'Available factories... hackrf' in info
 video=Path(tmp)/'test.mp4'
 run([rt/'bin/ffmpeg','-hide_banner','-loglevel','error','-f','lavfi','-i','testsrc2=size=320x240:rate=15','-f','lavfi','-i','sine=frequency=440:sample_rate=24000','-t','3','-c:v','libx264','-c:a','aac',video])
 print(run([rt/'bin/python3',r/'prepare.py',video,'20','0','200','0']))
 generated=Path(tmp)/'outputs/studio_tx.py'; assert generated.is_file()
 assert "'AMP', False" in generated.read_text()
 ts=Path(tmp)/'outputs/layer_a_si_prueba.ts';assert ts.stat().st_size>0
 print(run([rt/'bin/ffprobe','-v','error','-show_entries','stream=codec_name,width,height','-of','json',ts]))
 print('PASS: isolated HOME/PATH, bundled libraries only, TS preparation complete; no RF started.')
