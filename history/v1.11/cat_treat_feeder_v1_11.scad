/*
  Cat Treat Feeder V1.11 — 9.5 mm open front guide, BOTH clip roots reinforced, 2026-11-03
  Measured by user with ruler (approximate): stem width MIN 9mm MAX 14mm,
  thickness 6mm, slight longitudinal curve. These are NOT verified CAD dimensions.
  Spoon handle length calculated: 35 + 52 + 15 = 102 mm.
  The narrow point is 87 mm from tail; bowl junction is 102 mm from tail.
  Simulated spoon tail x=40 => wide point x=75, narrow point x=127, junction x=142.
  Rear clip remains 13.5 mm snap with OUTBOARD root gussets. Front is an open U guide (NO snap lip), nominal gap 9.5 mm.
  WARNING: front guide does not retain spoon vertically; rely on rear clip for retention.
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
// V1.11 front guide remains lip-free. Narrower fit per physical testing; roots strengthened.
front_guide_width = 9.5; // internal gap near the support plate; spoon narrow point ~9mm
front_guide_opening = 11.1; // 1.6mm-flared entry; no undercut, no bending required
// Rear snap width/mouth unchanged (13.5/11.7 mm), NOW with reinforced, outboard roots.
rear_wall_root_t = 4.6; // wide attachment to base plate, matches reinforced front
rear_wall_gusset = true; // external bracing without constricting the snap cavity
spoon_slot_height = 7.4;  // user measured ~6mm stem thickness plus curved allowance
body_raise = 4.7;        // lift former shell so a 6mm-thick handle fits BELOW bed
plate_bottom = 6.5 + body_raise;
spoon_clip_length = 12.0;
compression_gap = 2.0;         // empty space between packet bed and slider, mm
slider_clearance = 0.6;        // per side, mm
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

module body() {
    union() {
        translate([0,0,body_raise]) {
        // Main packet-supporting surface (one continuous plate).
        translate([0,0,plate_z0])
            linear_extrude(height=plate_thickness)
                rounded_strip2d(length,base_halfwidth*2,2.0);
        // Two pouch edge guards, leaving a wide open center for the tube.
        for (side=[-1,1])
            translate([7,side*(wall_inner_y+(side_outer_width-wall_inner_y)/2),plate_top])
                cube([121,side_outer_width-wall_inner_y,wall_top-plate_top]);
        // Small front stops on the OUTSIDE only: avoid blocking cat-tube mouth.
        for (side=[-1,1])
            translate([137.5,side*17.5,16.5])
                cube([6.0,3.0,14.0],center=true);
        } // translated pouch bed
        // Under-bed two-zone clips. Wide grip assumed near back of spoon handle.
        spoon_clip(rear_clip_x, rear_width, rear_mouth);
        spoon_front_guide(front_clip_x, front_guide_width, front_guide_opening);
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

// Front OPEN U-SADDLE guide with thick, fully bonded roots, NO snap lips.
// User reports V1.8 front snap wall tore off at the base under insertion force.
// For V1.11, lateral location is achieved without any snap deformation.
// Inner clearance is exactly 9.5mm nominal at the tight upper section; entry widens
// to 11.1mm at the lower lip. Both inward surfaces are smooth/straight to flared.
// Wider roots and OUTBOARD fillets reinforce the rail-bed interface without narrowing
// the slot. This is still a print-test prototype, not load-validated.
module spoon_front_guide(cx, internal_gap=front_guide_width, entry_gap=front_guide_opening) {
    rail_length = spoon_clip_length;  // 12mm
    rail_t = 3.6;
    root_t = 4.6;
    for(side=[-1,1]) {
        // Full-height tapered side rail, with a top flange embedded >1mm in bed.
        hull() {
            // Top: inner edge at +/- internal_gap / 2, broad root outside.
            translate([cx,side*(internal_gap/2+root_t/2),plate_bottom+0.65])
                cube([rail_length+3,root_t,2.0],center=true);
            // Bottom: wide inlet has no undercut; NO elastic clipping required.
            translate([cx,side*(entry_gap/2+rail_t/2),3.25])
                cube([rail_length,rail_t,2.0],center=true);
        }
        // External root gusset: stays OUTSIDE slot and joins the horizontal bed.
        // Adds material at sidewall base, where previous narrow snap wall broke.
        hull() {
            translate([cx,side*(internal_gap/2+4.5),plate_bottom+0.65])
                cube([rail_length+6,4.0,2.0],center=true);
            translate([cx,side*(internal_gap/2+2.85),plate_bottom-2.0])
                cube([rail_length+2,3.3,1.0],center=true);
        }
    }
}

// A captured U-shaped sliding squeegee. Insert from the rear of the main holder.
// Thin hooks at the feet keep the slider on the bed but avoid underside spoon clips.
module slider() {
    translate([0,0,body_raise]) slider_core();
}
module slider_core() {
    // Nominal envelope: 47.6 mm wide, 25.5 high. Slider travels along x.
    slider_x = 9;
    inner_y = base_halfwidth + slider_clearance;
    out_y = inner_y + 3.4;
    squeeze_z = plate_top + compression_gap;
    union() {
        // Thumb bridge and grip. It spans all the way across packet for pressure.
        translate([0,0,20.8]) cube([slider_x,2*out_y,5.4],center=true);
        // Broad, round-ended lower push bar across the pouch width.
        translate([0,0,(squeeze_z+21.0)/2]) cube([slider_x,2*(wall_inner_y-0.6),21.0-squeeze_z],center=true);
        // Two slim vertical side members
        for(side=[-1,1]) {
            translate([0,side*(inner_y+1.7),13.0])
                cube([slider_x,3.4,16.5],center=true);
            // Captured under-plate feet: they never touch the spoon handle clips.
            translate([0,side*(base_halfwidth-1.2),5.1])
                cube([slider_x,5.5,2.2],center=true);
        }
        // Round thumb tab: easier for a child to push with 1-2 fingers.
        translate([-1.8,0,25.0])
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

// Standalone low-material open-front guide test coupon.
module front_guide_coupon(width=front_guide_width, opening=front_guide_opening) {
    union() {
        translate([0,0,plate_bottom])
            linear_extrude(height=plate_thickness)
                rounded_strip2d(24,base_halfwidth*2,2);
        spoon_front_guide(12,width,opening);
    }
}
module front_guide_coupon_print(width=front_guide_width, opening=front_guide_opening) {
    translate([0,0,plate_bottom+plate_thickness]) rotate([180,0,0])
        front_guide_coupon(width,opening);
}

// Connected two-clip tester reproduces actual center-to-center spacing and clip geometry.
// Using only individual test pieces cannot reveal the longitudinal fit mismatch.
module two_clip_spacing_coupon() {
    union() {
        for(cx=[rear_clip_x, front_clip_x])
            translate([cx-12,0,plate_bottom])
                linear_extrude(height=plate_thickness)
                    rounded_strip2d(24,base_halfwidth*2,2);
        // Thin (but useful) top-side bridge to reduce material usage.
        translate([(rear_clip_x+front_clip_x)/2,0,plate_bottom+plate_thickness/2])
            cube([front_clip_x-rear_clip_x,12,plate_thickness],center=true);
        spoon_clip(rear_clip_x,rear_width,rear_mouth);
        // Both coupons use the same V1.11 reinforced rear snap and open front guide as the full body.
        spoon_front_guide(front_clip_x,front_guide_width,front_guide_opening);
    }
}
module two_clip_spacing_coupon_print() {
    translate([-rear_clip_x+12,0,plate_bottom+plate_thickness])
        rotate([180,0,0]) two_clip_spacing_coupon();
}

// Render-position helpers: spread parts into valid printing orientations.
module body_side_print() {
    // Rotate so body's -Y outer edge is at build plate (along the long x-axis).
    // y_old -> z_new; z_old -> -y_new. Add translation so nothing is below z=0.
    translate([0,26.0,19.0]) rotate([90,0,0]) body();
}
module slider_print() {
    // x_old -> z_new; z_old -> -x_new. Entire ring lies flat on slicer bed.
    translate([32,0,8.05]) rotate([0,-90,0]) slider();
}

if(part=="two_clip_spacing_coupon") two_clip_spacing_coupon_print();
else if(part=="rear_reinforced_coupon") rear_reinforced_coupon();
else if(part=="front_guide_coupon") front_guide_coupon_print();
else if(part=="front_guide_coupon_loose") front_guide_coupon_print(9.9,11.5);
else if(part=="body") body();
else if(part=="body_side_print") body_side_print();
else if(part=="slider") slider();
else if(part=="slider_print") slider_print();
else if(part=="spoon_demo") spoon_demo();
else if(part=="rear_coupon_standard") clip_coupon_print(rear_width,rear_mouth);
else if(part=="rear_coupon_tight") clip_coupon_print(rear_width-0.5,rear_mouth-0.5);
else if(part=="rear_coupon_loose") clip_coupon_print(rear_width+0.5,rear_mouth+0.5);
else if(part=="front_coupon_standard") front_guide_coupon_print();

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
