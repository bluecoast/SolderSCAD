#    SolderSCAD.py -- script to convert gerber solder stencil file to OpenSCAD file
#    version 0.1 -- 7 January 2013
#    Copyright (C) 2013 Andrew Barrow
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Gerber Format crib notes:
# '*' is mandatory end-of-block character
# G04 COMMENT*
# M02* end of program
# %MOIN*% Parameters must have '%' around them
# sometimes there are two blocks per line: G74*%blah*%
#
# PARAMETERS:
# FS Format Statement(only mandatory one)
#
# Recommended to only use once at start:
# AS Axis Select
# MI Mirror Image
# MO Mode
# OF Offset
# SF Scale Factor
#
# Use once only at start:
# IP Image Polarity
# IR Image Rotation
#
# AD Aperture Definition
# AM Aperture Macro
# LN Layer Name
# LP Layer Polarity
# KO Knockout
# SR Step and Repeat
# SM Symbol Mirror
#
# FUNCTION CODES:
# D01: Exposure and draw mode ON
# D02: Exposure and draw mode OFF
# D03: Set Flash mode.
# D10-D999: Select an aperture defined by an AD param
#
# G01 Set linear interpolation mode (default)
# G02 Set clockwise circular interpolation mode
# G03 Set counterclockwise circular interpolation mode

# G04 Ignore block (comment)
#
# G36 Turn on outline fill
# G37 Turn off outline fill
#
# G54 Select Aperture (actually deprecated)
#
# G70 Specify inches
# G71 Specify mm
# G74 Set single quadrant mode
# G75 Set multi-quadrant mode
# G90 Specify absolute format
# G91 Specify incremental format (recommended to use absolute only)
#
# M00 Program Stop
# M01 Optional Program Stop
# M02 End of Program

import math
import sys

output = [] #what we're going to write to the output file at the conclusion

if (len(sys.argv) > 1): # if an input file is specified, use that name. Use same name for outputfile.
    inputfile = sys.argv[1]
    outputfile = '{0}.SCAD'.format(inputfile.partition('.')[0])
else:
    inputfile = 'inputfile.SPT'
    outputfile = 'outputfile.SCAD'

if (len(sys.argv) > 2):   # if there's an output filename specified also, use that.
    outputfile = sys.argv[2] 

with open(inputfile, 'r') as f:
    content = f.read()
f.close()

with open('aperture_primitives.dat', 'r') as f:
    output.append(f.read())
f.close()
    
content = content.replace(' ','_')  #eliminate all whitespace
content = content.replace('*',' ')  #convert asterisks to new whitespace
blocks = content.split()            #split into blocks (asterisk delimited)

#Input gerber file axes: X, Y
#Output imaging device axes: A, B

param = False #Parameter state off at program start.
absolute = True #
trailing_zeros = False
axis_switch = False #set by AS. True maps X to Y, Y to X.
single_quadrant_mode = True #set by G74. Reset (Multi-quadrant mode) by G75.
Ascale = 1.0 
Bscale = 1.0
macrolist = [] #List of all defined aperture macro names
aperturelist = [] #List of all defined aperture numbers
unit_scale = 25.4 #default inch
difference_statement = False
draw_start_position = 0

for b in blocks:
    nextblock = blocks.index(b)+1
    if b[0] == '%':
        if len(b) == 1:
            param = False
            #print 'PARAM OFF'
        elif len(b) > 1:
            param = True
            b=b.lstrip('%')
            #print 'PARAM ON'
    if param == True:
        #print 'PARAMETER',b
        if b.startswith('FS'):
            b=b.partition('FS')[2]
            if b.startswith('L'):
                leading_zeros = True
                b=b.partition('L')[2]
            elif b.startswith('T'):
                leading_zeros = False
                b=b.partition('T')[2]
            else:
                print 'error: first part of Format Spec parameter must be L or T'
            if b.startswith('A'):
                absolute = True
            elif b.startswith('I'):
                absolute = False
            else:
                print 'error: second part of Format Spec must be A or I'
            xint = int(b.partition('X')[2][0])
            xdec = int(b.partition('X')[2][1])
            yint = int(b.partition('Y')[2][0])
            ydec = int(b.partition('Y')[2][1])
            if xint == yint and xdec == ydec:
                coord_len = xint + xdec 
                print 'Read format statement: leading zeros: {0}, absolute notation: {1}, decimal format: {2}.{3}'.format(leading_zeros, absolute, xint, xdec)
            else:
                print 'error: X and Y numeric formats don''t match.' 
        elif b.startswith('AS'):
            if b.partition('AS')[2] == 'AXBY':
                axis_switch = False
                print 'Axis mapping: X->A; Y->B (currently ignored)'
            elif b.partition('AS')[2] == 'AYBX':
                axis_switch = True
                print 'Axis mapping: Y->A; X->B (currently ignored)'
        elif b.startswith('MI'):
            print ''
        elif b.startswith('MO'):
            b=b.partition('MO')[2]
            if b == 'IN':
                unit_scale = 25.4
                print 'Gerber drawing unit: inch (output will be scaled to mm)'
            elif b=='MM':
                unit_scale = 1.0
                print 'Gerber drawing unit: mm'
            else:
                print 'error: mode must be IN or MM'
        elif b.startswith('OF'): #Offset of output from imaging device 0,0
            print ''
        elif b.startswith('SF'): #Scale Factor
            b = b.partition('SF')[2] #eat SF
            if b.startswith('A'):
                b=b.partition('A')[2] #eat A if it exists
                if len(b.partition('B')[0]) > 0: #B exists
                    Ascale = b.partition('B')[0] #Ascale to left of 'B'
                    Bscale = b.partition('B')[2] #Bscale to right of 'B'
                else: #B doesn't exist
                    Ascale = float(b) #Ascale is only part of B remaining. Do not change Bscale.
            elif b.startswith('B'):
                Bscale = float(b.partition('B')[2]) #Bscale to right of 'B'. Do not change Ascale.
            print 'A Scale = ', Ascale, ', B Scale = ', Bscale
        elif b.startswith('IP'):
            b = b.partition('IP')[2]
            if b == 'POS':
                IPPOS = True
                print 'Image polarity: positive (currently ignored)'
            else:
                IPPOS = False
                print 'Image polarity: negative (currently ignored)'
        elif b.startswith('IR'):        #Image Rotation. Can only be 0, 90, 180, 270.
            print ''
        elif b.startswith('AD'):        #capture aperture definitions and convert each one to a named OpenSCAD module we can call later
            b=b.partition('AD')[2]     #get everything to right of ADD
            if b[1:3].isdigit():        #100-999
                aperturename = b[0:3]
            else:
                aperturename = b[0:2]    #10-99
            aperturelist.append(aperturename)
            b=b.lstrip('D1234567890')
            if macrolist.count(b) > 0:  #we found a macro name. Not handling these yet.
                print 'Found aperture macro (currently ignored)', b
            elif b[0] == 'C': #Circle. 1-3 modifiers. Solid: circle diameter. Round hole: add hole diam. Rectangular hole: add X,Y hole dimensions
                b = b.lstrip('C,')
                #b = b.replace('X',' ') #convert X to space delimiting
                b = b.split('X')
                output.append('module {0}(){{\n'.format(aperturename))
                output.append('    gerb_circle(%s);\n' % ', '.join(map(str, b)))
                output.append('}\n')
            elif b[0] == 'R': #Rectangle. 2-4 modifiers. Solid: X and Y dimensions. Add holes as cirle.
                b = b.lstrip('R,')
                b = b.split('X')
                output.append('module {0}(){{\n'.format(aperturename))
                output.append('    gerb_rectangle(%s);\n' % ', '.join(map(str, b)))
                output.append('}\n')
            elif b[0] == 'O': #Obround. 2-4 modifiers as rectangle. Smallest sides terminated by half-circles.
                b = b.lstrip('O,')
                b = b.split('X')
                output.append('module {0}(){{\n'.format(aperturename))
                output.append('    gerb_obround(%s);\n' % ', '.join(map(str, b)))
                output.append('}\n')
            elif b[0] == 'P': #Polygon. 2-5 modifiers. Outer diameter.  Number of sides. Optional degree of rotation.
                b = b.lstrip('P,')#Round hole: add diam. Rect. hole: add X,Y hole dimensions. Must enter rotation to enter hole dimensions. Rot=0 for no rotation.
                b = b.split('X')
                output.append('module {0}(){{\n'.format(aperturename))
                output.append('    gerb_poly(%s);\n' % ', '.join(map(str, b)))
                output.append('}\n')
            else:
                print 'error -- aperture type must be C, R, O, P or an aperture macro name.'
        elif b.startswith('AM'):
            print ''
        elif b.startswith('LN'):
            print ''
        elif b.startswith('KO'):
            print ''
        elif b.startswith('SR'):
            print ''
        elif b.startswith('SM'):
            print ''
        elif b.startswith('IN'):
            b = b[2:len(b)]
            print 'Image name (from source Gerber):',b
            image_name = b
        else:
            pass
            
    else: #param == False
        if b[0] == 'G' or b[0] == 'g':
            if b.startswith('G04'):
                pass #ignore comment
            elif b.startswith('G74'):
                single_quadrant_mode = True
                print 'Single quadrant mode (currently ignored)'
            elif b.startswith('G75'):
                single_quadrant_mode = False
                print 'multi-quadrant mode (currently ignored)'
            elif b.startswith('G54'): #D-codes to call apertures may be preceeded by G54 (actually deprecated)
                b=b.partition('G54')[2] #strip that
                if (aperturelist.count(b) == 1): #we recognize a previously defined D code
                    working_aperture = b
                    #print 'working aperture',b
            else:
                #print 'GCODE', b
                pass
        elif (aperturelist.count(b) == 1): #we recognize a previously defined D code (no G54 present)
            working_aperture = b
            #print 'working aperture',b
        elif b.endswith('D03'): #flash with coordinates
            
            b=b.partition('D03')[0] #cut out the D03
            #print 'FLASH',b
            #if len(b) > xdec + xint + 1: #if there are both an X and Y coord
            if b.startswith('X'):
                b = b.lstrip('X')
                if b.startswith('-'):
                    X = int(b[0:xint+1])
                    X = X + int(b[xint+1:xint+xdec+1])/math.pow(10,ydec)
                else:
                    X = int(b[0:xint])
                    X = X + int(b[xint:xint+xdec])/math.pow(10,ydec)
                #print 'X',X
                b=b.lstrip('-0123456789')
            if b.startswith('Y'):
                b = b.lstrip('Y')
                if b.startswith('-'):
                    Y = int(b[0:yint+1])
                    Y = Y + int(b[yint+1:yint+ydec+1])/math.pow(10,ydec) 
                else:
                    Y = int(b[0:yint])
                    Y = Y + int(b[yint:yint+ydec])/math.pow(10,ydec)
                #print 'Y',Y
                b=b.lstrip('-0123456789')
            if (difference_statement == False):     #keep track of coordinate extremes to generate difference plane
                output.append('\n')
                output.append('// Start drawing stencil\n')
                draw_start_position = len(output)
                difference_statement = True;
                min_X = X
                min_Y = Y
                max_X = X
                max_Y = Y
            if (X < min_X):
                min_X = X
            if (X > max_X):
                max_X = X
            if (Y < min_Y):
                min_Y = Y
            if (Y > max_Y):
                max_Y = Y
            output.append('    scale(v=[{0},{1},1]) translate (v=[{2}, {3}, 0]) {4}();\n'.format(unit_scale*Ascale, unit_scale*Bscale,X,Y,working_aperture))
        elif (b == 'M02'):                          #END OF GERBER PROGRAM
            output.insert(draw_start_position,'difference(){\n') #put following at top of file
            output.insert(draw_start_position+1,'\n')
            output.insert(draw_start_position+2,'    // First draw the solid part\n')
            output.insert(draw_start_position+3,'    scale(v=[{0},{1},1]) translate(v=[{2},{3},0]) gerb_rectangle({4},{5});\n'.format(unit_scale*Ascale, unit_scale*Bscale, min_X+(max_X-min_X)/2, min_Y+(max_Y-min_Y)/2, max_X-min_X+20/unit_scale, max_Y-min_Y+20/unit_scale))
            output.insert(draw_start_position+4,'\n')
            output.insert(draw_start_position+5,'    // Then subtract each aperture flash from it\n') 
            output.append('}\n')
            print 'Reached end of Gerber input.'
        else:
            pass

with open(outputfile, 'w') as f:               
    for line in output:
        f.write(line)
f.close()
print 'Finished writing output file.'
print ''
print 'SolderSCAD Copyright (C) 2013 Andrew Barrow'
print 'This program comes with ABSOLUTELY NO WARRANTY.'
print 'This is free software, and you are welcome to'
print 'redistribute it under certain conditions.'
