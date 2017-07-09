from PIL import Image, ImageDraw
import subprocess as sp
import re
from ast import literal_eval as make_tuple
import sys

def rgb_to_hsl(r, g, b):
    r /= 255.
    g /= 255.
    b /= 255.
    maxrgb = float(max(r,g,b))
    minrgb = float(min(r,g,b))
    l = (minrgb + maxrgb) / 2
    if minrgb == maxrgb:
        return 0, 0.0, l

    if l <= 0.5:
        s = (maxrgb - minrgb) / (maxrgb + minrgb)
    else:
        s = (maxrgb - minrgb) / (2 - maxrgb - minrgb)

    if maxrgb == r:
        h = (g - b) / (maxrgb - minrgb)
    elif maxrgb == g:
        h = 2 + (b - r) / (maxrgb - minrgb)
    else:
        h = 4 + (r - g) / (maxrgb - minrgb)
    h = int(round(h * 60)) % 360

    return h, s, l

def hsl_to_rgb(h, s, l):
    h /= 360.
    if s == 0:
        return (255 * l,) * 3
    if l < 0.5:
        tmp1 = l * (1+s)
    else:
        tmp1 = l+s - l*s
    tmp2 = 2*l - tmp1
    tmpr = h + 1/3. if h <= 2/3. else h - 2/3.
    tmpg = h
    tmpb = h - 1/3. if h >= 1/3. else h + 2/3.
    return (tmpcolor(tmpr,tmp1,tmp2), tmpcolor(tmpg,tmp1,tmp2), tmpcolor(tmpb,tmp1,tmp2))

def tmpcolor(tmpc, tmp1, tmp2):
    if 6*tmpc < 1:
        c = tmp2 + tmpc*6*(tmp1 - tmp2)
    elif 2*tmpc < 1:
        c = tmp1
    elif 3*tmpc < 2:
        c = tmp2 + (tmp1 - tmp2)*(2/3. - tmpc)*6
    else:
        c = tmp2
    return int(round(255*c))


def get_colors(infile, outfile, numcolors=10, swatchsize=20, resize=150):

    image = Image.open(infile)
    image = image.resize((resize, resize))
    #result = image.convert('P', palette=Image.ADAPTIVE, colors=numcolors)
    #result.putalpha(0)
    #colors = result.getcolors(resize*resize)
    #colors = [tup[1] for tup in colors]

    magic_proc = sp.Popen(["convert", infile, "+dither", "-colors",
        str(numcolors), "-unique-colors", "txt:-"],
        stdout=sp.PIPE)

    raw_colors = magic_proc.stdout.readlines()
    del raw_colors[0] # Skip the first line which is not a color
    magic_colors = [re.search("rgb\(.*\)", str(col)).group(0)[3:] for col in raw_colors]
    magic_colors = [make_tuple(rgb_col) for rgb_col in magic_colors]

    hsl_colors = [rgb_to_hsl(col[0], col[1], col[2]) for col in magic_colors]

    # Minimum lightness
    min_lightness = 0.30
    max_lightness = 0.75

    bgcolor = min(hsl_colors, key=lambda tup: tup[2])
    hsl_colors = [tup for tup in hsl_colors if tup[2] >= min_lightness and tup[2] <= max_lightness]
    fgcolor = max(hsl_colors, key=lambda tup: tup[2])
    hue_selection = [bgcolor]
    #print(len(hsl_colors))
    hue_step = 25
    for i in range(0, 360/hue_step):
        tmp = [col for col in hsl_colors if col[0] >= hue_step*i and col[0] <= hue_step*(i+1)-1]
        if tmp:
            max_satur = max(tmp, key=lambda item:item[1])
            hue_selection.append(max_satur)
            #hsl_colors.remove(tmp[0])

    #hue_selection.append(hsl_colors[-1])

    # Save colors to file
    pal = Image.new('RGB', (swatchsize*len(hsl_colors) + 10, swatchsize))
    draw = ImageDraw.Draw(pal)

    # Sort colors by lightness
    hue_selection.sort(key=lambda tup: tup[2])

    posx = 0
    for col in hue_selection:
    #for col in hsl_colors:
        colrgb = hsl_to_rgb(col[0], col[1], col[2])
        colrgb = (int(colrgb[0]), int(colrgb[1]), int(colrgb[2]))
        print("RGB : " + str(colrgb) + " HSL : " + str(col))
        draw.rectangle([posx, 0, posx+swatchsize, swatchsize], fill=colrgb)
        posx = posx + swatchsize

    del draw
    pal.save(outfile, "PNG")

if __name__ == '__main__':
    get_colors(sys.argv[1], 'selectcolors.png', numcolors=200)
