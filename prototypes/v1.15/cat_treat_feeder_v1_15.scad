/*
  Cat Treat Feeder V1.15 — tighter removable slider, base/clip geometry unchanged, 2026-11-04
  Measured by user with ruler (approximate): stem width MIN 9mm MAX 14mm,
  thickness 6mm, slight longitudinal curve. These are NOT verified CAD dimensions.
  Spoon handle length calculated: 35 + 52 + 15 = 102 mm.
  The narrow point is 87 mm from tail; bowl junction is 102 mm from tail.
  Simulated spoon tail x=40 => wide point x=75, narrow point x=127, junction x=142.
  Rear clip remains 13.5 mm / 11.7 mm snap. Front now uses the SAME two-way ramp lip geometry and outboard root bracing; gap 9.5 mm, GENTLE mouth 8.7 mm.
  V1.14: squared-off FRONT (x=141) bed and front-stop end x=141.
  V1.15: reduce lateral slider free-play and CLOSE the former 4.1mm upper gap.
  V1.14 ORIGINAL slider is unchanged in current repo; this slider is a test prototype.
  Variants: slider_print (standard), slider_print_tight (tighter), slider_print_loose (looser).
  WARNING: front snap previously fractured. Start with gentle 8.7 mm mouth coupon; do not force in. 8.3 mm alternative is more aggressive and experimental.
  WARNING: Approximate ruler measurements, not a detailed measured spoon cross-section.
  Use TWO-CLIP spacing coupon before the full body; never force a brittle spoon.
  Printed parts are NOT food-contact components. This is NOT an approved/safety-tested product.
  parts: body_side_print, slider_print, two_clip_spacing_coupon, front_guide_coupon, front_guide_coupon_loose, rear_coupon_standard, rear_coupon_tight,
         rear_coupon_loose, front_coupon_standard, front_coupon_tight,
         front_coupon_loose, assembly, underside_preview
*/
part = "assembly";
$fn=40;

// ===== User-adjustable dimensions =====
// Widths below are at the two clip positions, NOT global extrema.
// V1.6 test: 13.5/11.7mm rear, 9.5/7.9mm front; reversible lip ramps.
// Test coupon BEFORE printing entire body; user measurements approx 14mm widest. Avoid forcing.
spoon_tail_x = 40;       // temporary spoon alignment: 102 mm to bowl junction x=142
wide_from_tail = 35;      // reported ruler measurement
narrow_from_wide = 52;    // reported ruler measurement
narrow_to_bowl = 15;      // reported ruler measurement
rear_clip_x = spoon_tail_x + wide_from_tail;
front_clip_x = rear_clip_x + narrow_from_wide;

rear_width = 13.5;        // nominal accommodation for spoon wider portion (~14 mm)
rear_mouth = 11.7;        // gentle snap undercut; test PETG compliance
// V1.13 front uses the same reversible diamond-lip style as the rear, NOT the old open guide.
front_width = 9.5;        // 9.5 mm internal gap; spoon narrow point ~9 mm
front_mouth = 8.7;        // GENTLE 0.8 mm nominal undercut vs width. Prior 7.9 mm front snap broke.
front_mouth_tighter = 8.3; // optional extra-retention test, DO NOT force
// Rear snap width/mouth unchanged (13.5/11.7 mm), NOW with reinforced, outboard roots.
rear_wall_root_t = 4.6; // wide attachment to base plate, matches reinforced front
rear_wall_gusset = true; // external bracing without constricting the snap cavity
spoon_slot_height = 7.4;  // user measured ~6mm stem thickness plus curved allowance
body_raise = 4.7;        // lift former shell so a 6mm-thick handle fits BELOW bed
plate_bottom = 6.5 + body_raise;
spoon_clip_length = 12.0;
compression_gap = 2.0;         // empty space between packet bed and slider, mm
slider_clearance = 0.35;       // V1.15, nominal lateral per-side gap (old 0.60)
slider_top_clearance = 0.45;   // V1.15, nominal top bridge to rail vertical gap (old 4.10)
slider_foot_clearance = 0.30;  // unchanged: underhook upper face to bed underside
// Note: nominal combined vertical free-play = top_clearance + foot_clearance
// PETG printer calibration may require looser variant; never force a slider that binds.
pouch_max_width = 29.5;       // width between packet side guides, mm

// ===== Main holder dimensions =====
length = 141;
base_halfwidth = 19;
plate_z0 = 6.5;
plate_thickness = 3.2;
plate_top = plate_z0 + plate_thickness;
wall_top = 14.0;
side_outer_width = 19.0;
wall_inner_y = pouch_max_width / 2;

// rounded 2D centered at y=0
module rounded_strip2d(L,W,r=2) {
    hull() for(x=[r,L-r],y=[-W/2+r,W/2-r]) translate([x,y]) circle(r=r);
}

// V1.14: front of bed is a TRUE flat x=length plane, while rear retains
// the prior 2 mm rounded end. V1.13 rounded BOTH ends; the little front
// rounded lip didn't line up with the square-ended front stop in side-print.
// This avoids a 0.5–2.0 mm stepped front lip in the slice silhouette.
module bed_profile_flat_front_2d(L,W,r=2) {
    union() {
        translate([r,-W/2]) square([L-r,W]);
        hull() for (y=[-W/2+r, W/2-r]) translate([r,y]) circle(r=r);
    }
}

// V1.14: position both front baffles exactly against the x=length cutoff.
// Preserves their preexisting proximal x-start at 134.5 mm.
front_stop_start_x = 134.5;
front_stop_end_x = length;
front_stop_length = front_stop_end_x-front_stop_start_x;
front_stop_center_x = (front_stop_start_x+front_stop_end_x)/2;

module body() {
    union() {
        translate([0,0,body_raise]) {
        // Main packet-supporting surface (one continuous plate).
        translate([0,0,plate_z0])
            linear_extrude(height=plate_thickness)
                bed_profile_flat_front_2d(length,base_halfwidth*2,2.0);
        // Two pouch edge guards, leaving a wide open center for the tube.
        // V1.12 FIX (preserved in V1.13): Center the positive-Y and negative-Y rails symmetrically.
        // V1.11 used a non-centered cube offset from an already centered Y,
        // shifting BOTH rails +2.125 mm and causing interference with slider.
        // Target rail Y ranges: [-19.0,-14.75] and [14.75,19.0] mm.
        for (side=[-1,1])
            translate([7+121/2,
                       side*(wall_inner_y+(side_outer_width-wall_inner_y)/2),
                       plate_top+(wall_top-plate_top)/2])
                cube([121, side_outer_width-wall_inner_y, wall_top-plate_top], center=true);
        // V1.14: both outside-only front stops finish flush at the same
        // x=length cut plane as the bed (not 0.5 mm short of it).
        // This also bridges the tiny front-end round-to-square mismatch
        // seen in an upright sliced print; inner packet channel unchanged.
        for (side=[-1,1])
            translate([front_stop_center_x,side*17.5,16.5])
                cube([front_stop_length,3.0,14.0],center=true);
        } // translated pouch bed
        // Under-bed two-zone clips. Wide grip assumed near back of spoon handle.
        spoon_clip(rear_clip_x, rear_width, rear_mouth);
        spoon_clip(front_clip_x, front_width, front_mouth);
    }
}

// V1.6 experimental TWO-WAY chamfered lips: shallow ramp from each direction.
// This is a rapid-removal prototype, not yet validated with a real PP spoon.
// User should press the handle evenly into both clips from below, then to remove
// apply a controlled downward pull near clip areas; no twisting required.
// Wedge ridge centered at z=2.80 and triangular shoulders at z=1.75 and 3.95.
// Minimal tip corners to reduce gouging spoon handle during removal.
module spoon_clip(cx, width, mouth) {
    clip_inner_half = width/2;
    mouth_half = mouth/2;
    translate([cx,0,0]) {
        for(side=[-1,1]) {
            translate([0,side*(clip_inner_half+1.175),(1.8+plate_bottom+0.6)/2])
                cube([spoon_clip_length,2.35,plate_bottom+0.6-1.8],center=true);
            // symmetric diamond lip: upper slope helps release, lower slope insertion
            hull() {
                translate([0,side*(clip_inner_half+0.18),1.87])
                    cube([spoon_clip_length-2.4,0.55,0.25],center=true);
                translate([0,side*(mouth_half+0.24),2.85])
                    cube([spoon_clip_length-2.4,0.48,0.30],center=true);
                translate([0,side*(clip_inner_half+0.18),3.86])
                    cube([spoon_clip_length-2.4,0.55,0.25],center=true);
            }
            // V1.11 rear reinforcement: like the front guide, broaden the wall root
            // INTO THE OUTSIDE ONLY. The inner face (width/2) and lip mouth remain
            // untouched, so the spoon-fit measurements are not silently changed.
            // 4.6-mm upper attachment, plus a sloping outboard triangular gusset.
            if (rear_wall_gusset) {
                hull() {
                    translate([0,side*(clip_inner_half+rear_wall_root_t/2),plate_bottom+0.65])
                        cube([spoon_clip_length+3,rear_wall_root_t,2],center=true);
                    translate([0,side*(clip_inner_half+1.175),5.05])
                        cube([spoon_clip_length,2.35,2.0],center=true);
                }
                hull() {
                    translate([0,side*(clip_inner_half+4.5),plate_bottom+0.65])
                        cube([spoon_clip_length+6,4.0,2.0],center=true);
                    translate([0,side*(clip_inner_half+2.85),plate_bottom-2.0])
                        cube([spoon_clip_length+2,3.3,1.0],center=true);
                }
            }
        }
    }
}

// V1.13 FRONT: spoon_clip() is deliberately reused here. Both ends have the
// same symmetrical two-way diamond snap lip, broad 4.6mm upper roots and
// outboard gussets. The front mouth is LESS aggressive (8.7mm, not 7.7mm)
// because a former 9.5mm/7.9mm front clip broke at the root. Geometry alone
// does not ensure sufficient snap durability; use coupons and never force.

// A captured U-shaped sliding squeegee. Insert from the rear of the main holder.
// Thin hooks at the feet keep the slider on the bed but avoid underside spoon clips.
module slider(lat_gap=slider_clearance, top_gap=slider_top_clearance) {
    translate([0,0,body_raise]) slider_core(lat_gap, top_gap);
}
module slider_core(lat_gap, top_gap) {
    slider_x = 9;
    inner_y = base_halfwidth + lat_gap;
    out_y = inner_y + 3.4;
    squeeze_z = plate_top + compression_gap;
    bridge_height = 5.4;
    // Rail upper face is wall_top. Bridge LOWER face is wall_top+top_gap.
    // Old bridge lower face = 20.8-2.7=18.1 vs rail_top=14.0; 4.1mm gap.
    bridge_center_z = wall_top + top_gap + bridge_height/2;
    // Keep the push tab CONNECTED to the lowered bridge (overlap 0.7mm).
    tab_center_z = bridge_center_z + bridge_height/2 + 2.0 - 0.7;
    union() {
        translate([0,0,bridge_center_z])
            cube([slider_x,2*out_y,bridge_height],center=true);
        translate([0,0,(squeeze_z+21.0)/2])
            cube([slider_x,2*(wall_inner_y-0.6),21.0-squeeze_z],center=true);
        for(side=[-1,1]) {
            translate([0,side*(inner_y+1.7),13.0])
                cube([slider_x,3.4,16.5],center=true);
            translate([0,side*(base_halfwidth-1.2),5.1])
                cube([slider_x,5.5,2.2],center=true);
        }
        translate([-1.8,0,tab_center_z])
            cube([12.5,17,4],center=true);
    }
}

// Approximate spoon envelope — visual guide ONLY, NOT for printing or feeding.
module spoon_demo() {
    // Schematic *unmeasured* outline, not an exact reverse engineered shape.
    // Along the x-axis: tail=40, widest=75, narrowest=127, bowl junction=142.
    color([0.91,0.95,0.99,0.68]) {
        // The handle is shown as a simple polygon using known widths only at 2 points.
        translate([0,0,4.2])
            linear_extrude(height=5.5)
                polygon(points=[
                    [40,-5.3],[62,-6.3],[75,-7],[97,-5.8],
                    [118,-4.7],[127,-4.5],[142,-5.3],
                    [142,5.3],[127,4.5],[118,4.7],
                    [97,5.8],[75,7],[62,6.3],[40,5.3]
                ]);
        // ~43mm x 53mm oval bowl envelope, illustrative only.
        translate([168.5,0,7]) scale([26.5,21.5,2.3]) sphere(1,$fn=48);
    }
}

module pouch_demo() {
    color([0.99,0.75,0.31,0.56]) {
        hull() {
            translate([15,0,12.8]) cube([5,25,2.7],center=true);
            translate([125,0,12.8]) cube([6,25,2.7],center=true);
            translate([153,0,13]) cube([3,10,1.4],center=true);
        }
    }
}

// Six small width-variant coupons. Print TWO standard gauges before a full base.
module clip_coupon(width, mouth) {
    union() {
        translate([0,0,body_raise+plate_z0])
            linear_extrude(height=plate_thickness)
                rounded_strip2d(24,base_halfwidth*2,2);
        spoon_clip(12,width,mouth);
    }
}
module clip_coupon_print(width,mouth) {
    // Put the formerly upper pouch-bed face down on build plate.
    translate([0,0,body_raise+plate_top]) rotate([180,0,0]) clip_coupon(width,mouth);
}

// Standalone rear snap coupon. Includes identical 4.6-mm upper root + outside gussets.
// Tests rear stiffness without printing full two-point unit.
// Front remains non-snap; rear undercut is unchanged (do not force fit).
module rear_reinforced_coupon() {
    clip_coupon_print(rear_width,rear_mouth);
}

// Standalone front snap coupon uses EXACTLY the full-body clip geometry.
module front_snap_coupon(mouth=front_mouth) {
    clip_coupon_print(front_width,mouth);
}

// Connected two-clip tester reproduces actual center-to-center spacing and clip geometry.
// Using only individual test pieces cannot reveal the longitudinal fit mismatch.
module two_clip_spacing_coupon(front_test_mouth=front_mouth) {
    union() {
        for(cx=[rear_clip_x, front_clip_x])
            translate([cx-12,0,plate_bottom])
                linear_extrude(height=plate_thickness)
                    rounded_strip2d(24,base_halfwidth*2,2);
        // Thin (but useful) top-side bridge to reduce material usage.
        translate([(rear_clip_x+front_clip_x)/2,0,plate_bottom+plate_thickness/2])
            cube([front_clip_x-rear_clip_x,12,plate_thickness],center=true);
        spoon_clip(rear_clip_x,rear_width,rear_mouth);
        // Both use exactly the same reinforced diamond-lip snap as full body.
        spoon_clip(front_clip_x,front_width,front_test_mouth);
    }
}
module two_clip_spacing_coupon_print(front_test_mouth=front_mouth) {
    translate([-rear_clip_x+12,0,plate_bottom+plate_thickness])
        rotate([180,0,0]) two_clip_spacing_coupon(front_test_mouth);
}

// Render-position helpers: spread parts into valid printing orientations.
module body_side_print() {
    // Rotate so body's -Y outer edge is at build plate (along the long x-axis).
    // y_old -> z_new; z_old -> -y_new. Add translation so nothing is below z=0.
    translate([0,26.0,19.0]) rotate([90,0,0]) body();
}
module slider_print(lat_gap=slider_clearance,top_gap=slider_top_clearance) {
    // Retain V1.14 printing orientation / original grip position on slicing bed.
    translate([32,0,8.05]) rotate([0,-90,0]) slider(lat_gap,top_gap);
}

if(part=="two_clip_spacing_coupon") two_clip_spacing_coupon_print();
else if(part=="two_clip_spacing_coupon_tighter") two_clip_spacing_coupon_print(front_mouth_tighter);
else if(part=="rear_reinforced_coupon") rear_reinforced_coupon();
else if(part=="front_snap_coupon") front_snap_coupon();
else if(part=="front_snap_coupon_tighter") front_snap_coupon(front_mouth_tighter);
else if(part=="body") body();
else if(part=="body_side_print") body_side_print();
else if(part=="slider") slider();
else if(part=="slider_print") slider_print(0.35,0.45);
else if(part=="slider_print_tight") slider_print(0.25,0.30);
else if(part=="slider_print_loose") slider_print(0.45,0.70);
else if(part=="spoon_demo") spoon_demo();
else if(part=="rear_coupon_standard") clip_coupon_print(rear_width,rear_mouth);
else if(part=="rear_coupon_tight") clip_coupon_print(rear_width-0.5,rear_mouth-0.5);
else if(part=="rear_coupon_loose") clip_coupon_print(rear_width+0.5,rear_mouth+0.5);
else if(part=="front_coupon_standard") front_snap_coupon();

else if(part=="rear_coupon_strong") clip_coupon_print(rear_width,rear_mouth-0.6);


else if(part=="underside_preview") {
    rotate([180,0,0]) {
        color("#74a5b9") body();
        translate([32,0,0]) color("#f7b15e") slider();
        spoon_demo();
    }
}
else {
    color("#74a5b9") body();
    translate([32,0,0]) color("#f7b15e") slider();
    spoon_demo();
    pouch_demo();
}
