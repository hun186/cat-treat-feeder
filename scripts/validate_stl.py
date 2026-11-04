#!/usr/bin/env python3
"""Check printable STL geometry; passing is not physical or food-safety approval."""
from pathlib import Path
import sys
import trimesh

files = [Path(s) for s in sys.argv[1:]]
if not files:
    files = sorted((Path(__file__).resolve().parents[1] / "current").glob("*.stl"))
if not files:
    sys.exit("No STL files found")
ok = True
for path in files:
    mesh = trimesh.load_mesh(path, force="mesh")
    parts = mesh.split(only_watertight=False)
    passed = bool(mesh.is_watertight and mesh.is_winding_consistent and len(parts) == 1 and mesh.volume > 0)
    print(f"{'PASS' if passed else 'FAIL'} {path.name} watertight={mesh.is_watertight} winding={mesh.is_winding_consistent} parts={len(parts)} volume_mm3={mesh.volume:.2f}")
    ok &= passed
sys.exit(0 if ok else 1)
