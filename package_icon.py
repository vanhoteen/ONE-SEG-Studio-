"""Package resized PNG resources in the macOS ICNS container."""
import struct
import sys
from pathlib import Path
folder = Path(sys.argv[1])
entries = [('ic07','icon_128x128.png'), ('ic08','icon_256x256.png'),
           ('ic09','icon_512x512.png'), ('ic10','icon_512x512@2x.png')]
chunks = []
for kind, name in entries:
    data = (folder/name).read_bytes()
    chunks.append(kind.encode('ascii') + struct.pack('>I',len(data)+8) + data)
payload = b''.join(chunks)
Path(sys.argv[2]).write_bytes(b'icns'+struct.pack('>I',len(payload)+8)+payload)
