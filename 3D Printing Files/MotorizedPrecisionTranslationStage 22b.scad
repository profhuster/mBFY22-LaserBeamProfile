/*************************************************************
X-Y Precision Translation Stage.

(c) Michael Huster 2017, please share under CC-BY 3.0
You can use it for what you like, but attribution would be 
very nice.  Thanks!

v 17c - inspired by open microscope, but flex joints were vertical - Won't work
v 17d - flex joints are horizontal
v 17f - band pulls stage away from adj screw
v 18a - made a little heftier by increasing stageTh, tongueL
  and fixed pillarTh & bandTab for rubber band tongue
  Removed hold_from_bottom and square_to_circle because not used
  Added knobs to attach to stepper motor
v18b - changed to two mount holes
v22a - Added mount arm and holder for light sensor.
v22b - Changed nut capture to sliding groove for drive screw.
*************************************************************/
include <screws.scad>
// $fn=96;
$fn=24;
eps=0.01;
eps2 = 2 * eps;
i2m = 25.4;

printKnobs = false;
printBase = true;
printMotor = false;
printMount = true;
printSpacer = false;
// options
echo("\n=====\n");
// flexure parameters
flex_w = 4; // width of XY axis flexures
flex_l = 1.5;    // length of (all) flexible bits
flex_t = 0.75;   // thickness of (all) flexible bits
flex = [flex_w, flex_l, flex_t]; // the above in new-style format

// Octogon Stage with steps in bottom to help unsupported build
stageW = 40;
stageTh = 8;
stageH = 44; // height from bottom of base to top of stage
step = 0.4; // set step = 0 for no indents in bottom

gapW = 2;  // gap around flex column

tongueL = 16; // length of tongue for adjustment screw
pillarTh = 7; // thickness of interior post to support rubber band
bandTab = 1; // tab to hook rubber band on

// Knob and Motor Adapter
knobDia = 15;
knobTh = 6;
// screw dimensions for M3 bolt & nut
screwD = 3;
screwClr = 0.5;
headW = 5.5;
DY = 1.0; // Amount to enlarge drive hole due to tilting

// imperial 8/32 mount hole
mountHole = nc8_32free + screwClr;

// Stepper Motor Adapter
D_clr = 0.2;
D_dia = 5.0 + 2 * D_clr;
D_flat = 3.0 + 2 * D_clr;

// Stepper Motor Mount
// 28BYJ-48 Motor. 48 steps/rev + 1/16 reduction
holeSep = 35; // distance between mounting holes
holeToAxel = 8; // distance from mounting holes to center of axis
mountD2 = 3.5; // Dist of mount from mount holes
mountD1 = 17; // Dist to end of motor
mountTh = 17.5; // Dist from mount surface to motor surface
mountW = 42;
mountL = 30;
motorZ = stageH-stageTh-screwD;
holeHeight = 25;
clrHoleHeight = holeHeight + holeToAxel;
clrHoleDia = knobDia + 2;

// Mount for light sensor
lightMntW = 26;
lightMntL = 80;
lightMntTh = 8;
lightMntH = 75;
lightGrooveW = 15;
lightGrooveH = 18;
lightGrooveD = lightMntTh+eps2;
holeY = [-0.4*i2m, 0.4*i2m, -0.4*i2m, 0.4*i2m];
holeZ = [-0.1*i2m,-0.1*i2m, -0.6*i2m,-0.6*i2m];
holeD = 0.1*i2m;


module lightMnt(){
    color("thistle")
        translate([stageW/2-2,-lightMntW/2, 0])
            cube([lightMntL, lightMntW, lightMntTh]);
    color("thistle")
    difference(){
        translate([stageW/2+lightMntL-lightMntTh/2,
                    -lightMntW/2, 0])
            cube([lightMntTh, lightMntW, lightMntH]);
        translate([stageW/2+lightMntL-lightMntTh/2-eps,
                    -(lightGrooveW)/2, lightMntH-lightGrooveH+eps])
            cube([lightGrooveD, lightGrooveW, lightGrooveH]);
        for(i=[0:1:3]){
            translate([stageW/2+lightMntL-lightMntTh-eps,
                       holeY[i],
                       lightMntH+holeZ[i]])
                rotate([0,90,0])
                cylinder(h=2*lightMntTh, d=holeD);
        }
    }
}

module motorMount(){
  difference(){
    hull() {
      cube([mountW,mountL,2]);
      translate([0,0,mountTh-1])
        cube([mountW,mountD1,1]);
    }
    translate([mountW/2-holeSep/2,mountL-holeHeight,-eps])
      cylinder(d=nc6_32tap, h=mountTh+eps2);
    translate([mountW/2+holeSep/2,mountL-holeHeight,-eps])
      cylinder(d=nc6_32tap, h=mountTh+eps2);
    translate([mountW/2,0,-eps])
      cylinder(d=clrHoleDia, h=mountTh+eps2);
  }
}
if(printMotor && !printBase){
  color("skyblue")
  translate([20,-80,0])
  motorMount();
}

thetaMax = asin(flex_l / stageTh);
echo("Max angle is ", thetaMax);
echo("1/cos(thetaMax) = ", 1/cos(thetaMax));
echo("Max DX is ", 2*(stageH - stageTh) * sin(thetaMax));
echo("Delta Z is ", (1 - cos(thetaMax)) * (stageH - stageTh));
//
// Modules
//
module stage(W, Th, inset){
    // W is width across flats
    // Th is the thickness of the stage
    // inset (if > 0) is how much is cut away to assist the build
    w2 = W / (1 + sqrt(2));
    lSq1 = (W + w2 / 3) / sqrt(2);
    difference(){
        // Use a cylinder with 8 facets to get an octogon
        rotate([0,0,45/2])
            cylinder(d=W/cos(45/2), h=Th, $fn=8);
        // Optional inset stage to make the build easier
        if(inset != 0){
            translate([0,0,-eps])
            rotate([0,0,45/2])
                cylinder(h=1,d=W-Th,$fn=8);
            translate([0,0,1-eps])
            rotate([0,0,45/2])
                cylinder(h=inset-1,d1=W-Th,d2=2*Th,$fn=8);
        }
    }
}

// A Bar of width W, and length L  and thickness Th with a flex hinge at each end
module flexureBar(flex, W, H, Th){
    // flex = [w,l,th]
    translate([-flex[0]/2, 0, 0])
      cube(flex);
    translate([-flex[0]/2, flex[1], 0])
      cube([W,Th,H]);
    translate([-flex[0]/2, 0, H-Th])
      cube(flex);
}

module tongue(W, legL, off, H, Th, gap){
    //color("red")
    union(){
        difference(){
            union(){
                // make U base
                reflect([1,0,0])
                linear_extrude(Th)
                    polygon([[0,0],[W/2+gap,0],[W/2+gap,legL],
                        [W/2+gap+Th,legL],[W/2+gap+Th,-Th],[0,-Th]]);
                // vertical piece
                translate([-W/2,-Th,0])
                    cube([W, Th, H]); 
            }
            translate([0,-Th-eps,H-Th-screwD])
                rotate([-90,0,0])
                cylinder(d=screwD+screwClr, h=Th+eps2);
        }
    }
}

module nutSlot(W, clr, Th){
    translate([-(W+clr)/2,-(W+clr),0])
        cube([W+1.5*clr,2*(W+clr),Th]);
}

module nutHole(W, clr, Th){
    cylinder(d=(W+clr)*(2/sqrt(3)),h=Th,$fn=6);
}

module base(W, Th, H, st, tL, gap){
    w2 = W / (1 + sqrt(2));
    difference(){
        union(){
            // bottom stage
            stage(W, Th, 0);
            // top stage
            translate([0,0,H - Th])
                stage(W, Th, Th/2);
            // Removable columns for support during build
            reflect([0,1,0])
            reflect([1,0,0]){
                translate([W/2-flex_w,w2/2-flex_t,0])
                    cube([flex_w,flex_t,H]);
                rotate([0,0,90])
                translate([W/2-flex_w,w2/2-flex_t,0])
                    cube([flex_w,flex_t,H]);
            }
            translate([0,-43.9,mountL])
              rotate([0,180,0])
              translate([-mountW/2,0,0])
              rotate([90,0,0])
              motorMount();
        }
        // mount holes in upper and lower stages
        // Upper
        translate([0,0,H-Th])
            cylinder(d=mountHole, h=Th+eps2);
        // Lower. v18b two holes 1/2 inch apart
        translate([0,0,-eps])
            cylinder(d=mountHole, h=Th+eps2);
        translate([0,0-25.4/2,-eps])
            cylinder(d=mountHole, h=Th+eps2);
    }
    // Add flex pillars
    color("cornflowerblue",.9)
    reflect([0,1,0]){
        translate([(w2-flex[0])/2, W/2, 0])
            flexureBar(flex, flex[0], H, Th);
        translate([-(w2-flex[0])/2, W/2, 0])
            flexureBar(flex, flex[0], H, Th);
        // support pillar with adjustment screw hole
        // and nut capture inset
        difference(){
            translate([-(w2-flex[0])/2,W/2+flex[1],0])
                cube([w2-flex[0],Th,H]);
            // v22a enlarge hole vertically due to leaning
            hull(){
              translate([0,W/2+flex[1]+eps,H-Th-screwD])
                rotate([-90,0,0])
                translate([0, DY,0])
                cylinder(d=screwD+screwClr, h=Th+eps2);
              translate([0,W/2+flex[1]+eps,H-Th-screwD])
                rotate([-90,0,0])
                translate([0,-DY,0])
                cylinder(d=screwD+screwClr, h=Th+eps2);
            }
            translate([0,W/2+flex[1]-eps,H-Th-screwD])
                rotate([-90,0,0])
                nutSlot(headW, screwClr, Th/2);
        }
    }
    // tongue to hold adjustment screw
    color("salmon", 0.9)
    translate([0,-W/2-tL,0])
        tongue(w2, tL+W/2, tL, H, Th, gap);

    // tongue to hold rubber band
    translate([-w2/2,pillarTh,0])
        cube([w2, pillarTh, H-Th-screwD]);
    // tab at top to hold rubber band on
    translate([-w2/2,pillarTh,H-Th-screwD-2])
        cube([w2, pillarTh+bandTab, 2]);
}

if(printBase){
    base(stageW, stageTh, stageH, step, tongueL, gapW);
    lightMnt();
}


module reflect(axis){ //reflects its children about the origin, but keeps the originals
	children();
	mirror(axis) children();
}

// Knob but also adapter to use stage with a stepper motor
module driveKnob(){
  color("palegreen")
  difference(){
    // Basic knob
    cylinder(d=knobDia, h=knobTh);
    // clearance hole for screw
    translate([0,0,-eps])
      cylinder(d=screwD+screwClr, h=knobTh+eps2);
    // inset for screw head
    translate([0,0,3])
      nutHole(headW, screwClr, knobTh+eps+3);
  }
  color("palegreen")
  translate([0,-knobDia-1,0])
  difference(){
    // Basic knob
    cylinder(d=knobDia, h=knobTh);
    // clearance hole for screw
    translate([0,0,-eps])
      cylinder(d=screwD+screwClr, h=knobTh+eps2);
    // hole for motor shaft
    translate([0,0,-eps])
      dHole(knobTh+eps2);
  }  
}

module dHole(h){
  intersection(){
    cylinder(d=D_dia, h=h);
    translate([-D_flat/2,-D_dia/2,0]) cube([D_flat,D_dia,h]);
  }
}
//translate([30,0,0]) dHole(stageTh);

if(printKnobs)
  translate([0,-60,0])
    driveKnob();

module mount(){
  difference(){
    cube([stageTh/2,stageW,stageW]);
    translate([-eps,stageW/4,stageW/4])
      cube([stageTh/2+eps2,stageW/2,stageW/2]);
  }
}

if(printMount)
  translate([0,-stageW/2,stageH-eps])
    mount();

module spacer(){
    difference(){
        cylinder(h=2, d=40, $fn=8);
        translate([0,0,-eps])
            cylinder(h=2+eps2, d=mountHole);
    }
}
if(printSpacer){
    translate([0,-110,0])
    color("plum")
    spacer();
}

// EOF