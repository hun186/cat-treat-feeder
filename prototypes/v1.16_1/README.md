# Cat Treat Feeder V1.16.1 — flush front stops for side-upright printing

This is a small **V1.16 base-only geometry fix**. The V1.16 standard 1.2 mm squeeze slider, 1.6 mm gentle alternative, and V1.15-tight rail-fit clearances remain **unchanged**.

| Parameter | V1.16 | V1.16.1 |
|---|---:|---:|
| Rail thickness (Y, each side) | 4.25 mm | 4.25 mm |
| Front stop thickness (Y, each side) | 3.00 mm | **4.25 mm** |
| Inner face of stop (absolute Y) | 16.00 mm | **14.75 mm**, now flush with rail |
| Outer face of stop (absolute Y) | 19.00 mm | 19.00 mm (unchanged) |
| Stop longitudinal range X | 139.5–146.0 mm | unchanged (6.5 mm length) |
| Rail X end and overlap | 140.0 mm / 0.5 mm overlap | unchanged |
| Base front plane X | 146.0 mm | unchanged |
| Front/rear spoon clips | 9.5/13.5 mm, 52 mm centers | unchanged |

The support-generating inward 1.25 mm ledge at the rail/stop transition is removed by aligning the stop's inner Y face with the rail. No forward travel geometry or squeeze pressure has been altered.

## Local verification
- OpenSCAD CGAL export of the V1.16.1 base complete.
- STL watertight, winding consistent, one connected component, positive volume (25299.565 mm³); V1.16 base volume 25080.690 mm³, change +218.875 mm³; overall bounding box unchanged.
- Interference tests with 1.2, 1.6, and 0.9 mm squeeze variants: no positive-volume overlap through slider center x=135.0; front hard-stop contact at x=135.7 (32.1300 mm³ intersection).
- **Not yet inspected in the user's slicer**, so do not assert completely support-free printing. Only the specific recessed ledge is addressed. No real spoon fit or feeding safety trial done.

Downloadable STL and ZIP were supplied in the conversation. This PR records the editable source and verification.
