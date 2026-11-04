# Geometry QA — V1.16.1

- Target: undercut ledge at V1.16 rail ↔ front-stop boundary under side-upright print orientation.
- Rail inner |y|=14.75 mm; original stop inner |y|=16.00 mm; new stop inner |y|=14.75 mm.
- Stop longitudinal bounds remain [139.5,146.0] mm, rail endpoint stays x=140 with 0.5 mm overlap.
- No changes to clips, bed, slider, slider travel or 1.2/1.6/0.9 squeeze gaps.
- New base STL exported locally with OpenSCAD: watertight=true, winding_consistent=true, connected_components=1, volume=25299.565 mm^3, unchanged bounding box.
- CGAL collision: no overlap at slider center x=17,75,125,130,134.5,135 for standard 1.2mm gap; no overlap at x=17,75,135 for gentle 1.6mm and experimental 0.9mm. All hit positive stop at x=135.7.
- **Slicer support preview NOT TESTED.** Actual PETG fit, support, spoon bowl, fatigue, pouch leak/rupture and child/cat safety NOT TESTED.
- Gate: Do not promote PR from draft until user confirms the support preview and dry fit.
