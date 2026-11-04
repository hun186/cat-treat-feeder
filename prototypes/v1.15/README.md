# V1.15 slider-clearance experiment (not yet physically validated)

**Use with unchanged V1.14 base.** A printed V1.14 body is not obsolete.

User observed lateral and vertical looseness. Source inspection found V1.14 slider lateral clearance **0.60 mm/side** and top bridge to guardrail gap **4.10 mm**, plus foot-to-bed underside gap 0.30 mm.

| Selector | Lateral gap per side | Top gap | Nominal total lateral play | Nominal total vertical play |
|---|---:|---:|---:|---:|
| `slider_print` | 0.35 mm | 0.45 mm | 0.70 mm | 0.75 mm |
| `slider_print_tight` | 0.25 mm | 0.30 mm | 0.50 mm | 0.60 mm |
| `slider_print_loose` | 0.45 mm | 0.70 mm | 0.90 mm | 1.00 mm |

Download the prebuilt STL from the ChatGPT V1.15 ZIP attachment; this PR contains parametric OpenSCAD source and instructions; STL archival to GitHub awaits fit feedback.

**CAD checks performed locally:** all three STLs watertight, consistent winding, one connected component, positive volume. CGAL intersection of each with V1.14 base at longitudinal x=15,35,55,75,95,120 mm was empty. Original V1.14 base geometry is unchanged (same bounds, vertices, faces and volume).

**Limit:** CAD pass does not imply real-world printed fit, minimum force, safety or hygiene approval. Print **standard** first, move gently through travel with no treat/spoon; if binding use loose, if still wobbly use tight. Stop if PETG whitens, cracks or scratches badly. The lower squeeze bar and hooks remain at their original heights.
