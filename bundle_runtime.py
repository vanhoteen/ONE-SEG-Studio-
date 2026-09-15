"""Build a relocatable Apple Silicon runtime from the verified local installation."""
from pathlib import Path
import shutil, subprocess, os, json
P=Path(__file__).resolve().parent
R=P/'ONE SEG Studio.app/Contents/Resources/Runtime'
R.mkdir(parents=True,exist_ok=True)
origins={}
def copy(src,dst):
 src=Path(src).resolve(); dst=Path(dst)
 if src.is_dir():
  for s in src.rglob('*'):
   if s.is_file() and '__pycache__' not in s.parts and '.backup-' not in s.name: copy(s,dst/s.relative_to(src))
 else:
  dst.parent.mkdir(parents=True,exist_ok=True); shutil.copy2(src,dst); dst.chmod(dst.stat().st_mode|0o200); origins[dst]=src
F=Path('/opt/homebrew/opt/python@3.14/Frameworks/Python.framework/Versions/3.14').resolve()
copy(F/'Python',R/'python/Python')
copy(F/'Resources/Python.app/Contents/MacOS/Python',R/'bin/python3')
for item in (F/'lib/python3.14').iterdir():
 if item.name not in ('site-packages','__pycache__','test','idlelib','tkinter','ensurepip'): copy(item,R/'python/lib/python3.14'/item.name)
site=R/'python/lib/python3.14/site-packages'
G=Path('/opt/homebrew/lib/python3.14/site-packages')
copy(G/'pmt',site/'pmt')
for s in (G/'gnuradio').glob('*.py'): copy(s,site/'gnuradio'/s.name)
for n in ['gr','blocks','digital','dtv','fft','filter','soapy','isdbt','analog','pdu','fec','trellis','network']: copy(G/'gnuradio'/n,site/'gnuradio'/n)
copy('/opt/homebrew/opt/numpy/lib/python3.14/site-packages/numpy',site/'numpy')
for n in ['ffmpeg','ffprobe','tstabcomp','SoapySDRUtil']: copy('/opt/homebrew/bin/'+n,R/'bin'/n)
copy('/opt/homebrew/lib/SoapySDR/modules0.8/libHackRFSupport.so',R/'modules/libHackRFSupport.so')
copy('/opt/homebrew/share/tsduck',R/'share/tsduck')
# Resolve and rewrite every non-system Mach-O dependency recursively.
def macho(p):
 return p.read_bytes()[:4] in (b'\xcf\xfa\xed\xfe',b'\xca\xfe\xba\xbe',b'\xca\xfe\xba\xbf',b'\xce\xfa\xed\xfe')
queue=[p for p in origins if macho(p)]; seen=set()
while queue:
 p=queue.pop()
 if p in seen:continue
 seen.add(p); src=origins[p]
 lines=subprocess.check_output(['otool','-L',str(src)],text=True).splitlines()[1:]
 for line in lines:
  dep=line.strip().split(' (')[0]
  if dep.startswith(('/usr/lib/','/System/')):continue
  candidates=[Path(dep),src.parent/Path(dep).name,src.parent/dep.replace('@loader_path/',''),Path('/opt/homebrew/lib')/Path(dep).name]
  resolved=next((x.resolve() for x in candidates if x.is_file()),None)
  if not resolved: raise RuntimeError(f'Unresolved {src}: {dep}')
  if resolved==src: continue
  target=next((d for d,s in origins.items() if s==resolved),None)
  if target is None:
   target=R/'lib'/resolved.name
   if target in origins and origins[target]!=resolved:raise RuntimeError('Library name collision')
   copy(resolved,target);queue.append(target)
  relative='@loader_path/'+os.path.relpath(target,p.parent)
  subprocess.run(['install_name_tool','-change',dep,relative,str(p)],check=True,capture_output=True)
 # Remove external rpaths; all dependencies now use loader-relative paths.
 load=subprocess.check_output(['otool','-l',str(p)],text=True).splitlines()
 for i,line in enumerate(load):
  if line.strip()=='cmd LC_RPATH':
   rp=load[i+2].strip().split('path ',1)[1].split(' (offset')[0]
   if rp.startswith('/opt/homebrew'):subprocess.run(['install_name_tool','-delete_rpath',rp,str(p)],check=True,capture_output=True)
 subprocess.run(['codesign','--force','--sign','-',str(p)],check=True,capture_output=True)
print(f'Bundled and signed {len(seen)} native binaries',flush=True)
(R/'manifest.json').write_text(json.dumps({str(p.relative_to(R)):str(s) for p,s in origins.items()},indent=2))
# Preserve upstream copyright/license files from the formulas used.
for src in set(origins.values()):
 parts=src.parts
 if 'Cellar' not in parts:continue
 i=parts.index('Cellar'); formula=Path(*parts[:i+3])
 for pattern in ('*LICENSE*','*COPYING*','*COPYRIGHT*'):
  for f in formula.glob(pattern):
   if f.is_file():copy(f,R/'licenses'/formula.parent.name/f.name)
