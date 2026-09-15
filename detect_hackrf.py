"""Check HackRF discovery and access without creating a transmit stream."""
from pathlib import Path
import re
import subprocess
import sys


def check(tool):
    def run(args):
        result = subprocess.run([str(tool), *args], capture_output=True, text=True, timeout=12)
        return result.returncode, result.stdout + result.stderr

    code, output = run(['--find=driver=hackrf'])
    if code or not re.search(r'^\s*driver\s*=\s*hackrf\s*$', output, re.MULTILINE):
        print('HackRF no encontrado. Revisa el USB y cierra otras aplicaciones SDR.', flush=True)
        print(output)
        return 2
    code, output = run(['--probe=driver=hackrf'])
    # The device report uses lowercase "hardware=" in SoapySDR 0.8.
    # Status comes from the process, not from capitalized presentation headings.
    if code:
        print('HackRF detectado, pero no se pudo abrir. Puede estar ocupado o sin acceso.', flush=True)
        print(output)
        return 3
    print('HackRF detectado y accesible. No se ha iniciado RF.', flush=True)
    return 0


if __name__ == '__main__':
    # Prefer bundled tools when the portable runtime is added.
    bundled = Path(__file__).parent / 'Runtime/bin/SoapySDRUtil'
    tool = bundled
    try:
        sys.exit(check(tool))
    except FileNotFoundError:
        print('No se encuentra la herramienta de detección SoapySDR.', flush=True)
        sys.exit(4)
    except subprocess.TimeoutExpired:
        print('El HackRF no respondió a tiempo. Reconecta el USB y vuelve a detectar.', flush=True)
        sys.exit(5)
