from utils import contrast_norm
from PIL import Image, ImageDraw
from utils import color_dist, contrast
import subprocess as sp
import re
from ast import literal_eval as make_tuple
import sys
import random

def rgb_to_hex(colrgb):
    return '#%02x%02x%02x' % (colrgb[0], colrgb[1], colrgb[2])

def hsl_to_hex(colhsl):
    colrgb = hsl_to_rgb(colhsl)
    return rgb_to_hex(colrgb)

def rgb_to_hsl(colrgb):
    r = colrgb[0] / 255.
    g = colrgb[1] / 255.
    b = colrgb[2] / 255.
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

def hsl_to_rgb(colhsl):
    h, s, l = colhsl
    h /= 360.
    if s == 0:
        return (int(round(255 * l)),) * 3
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

# The color must be in HSL format
def find_label(col, labels):
    for i, l in enumerate(labels):
        if col[0] >= l[0] and col[0] < l[1]:
            return i
    return -1

def get_colors(infile, outfile, numcolors=10, swatchsize=20, resize=150):

    color_labels = [[15+30*i, 15+30*(i+1)] for i in range(12)] # Color intervals (e.g. red, cyan)
    color_labels.append([345, 15]) # Special case for red

    # Needed for quality magic stuffs
    magic_proc = sp.Popen(["convert", infile, "+dither", "-colors",
        str(numcolors), "-unique-colors", "txt:-"],
        stdout=sp.PIPE)
    raw_colors = magic_proc.stdout.readlines()
    del raw_colors[0] # Skip the first line which is not a color
    magic_colors = [re.search("rgb\(.*\)", str(col)).group(0)[3:] for col in raw_colors]
    magic_colors = [make_tuple(rgb_col) for rgb_col in magic_colors]

    hsl_colors = [rgb_to_hsl(col) for col in magic_colors]

    # Minimum lightness
    min_lightness = 0.25
    max_lightness = 0.75

    bgcolor = min(hsl_colors, key=lambda tup: tup[2])
    fgcolor = max(hsl_colors, key=lambda tup: tup[2])
    hue_selection = []
    labeled_colors = [[] for k in range(12)]
    good_colors = [col for col in hsl_colors if col[2] >= min_lightness and col[2] <= max_lightness and col[1] >= 0.3]
    for col in good_colors:
        id_label = find_label(col, color_labels)
        labeled_colors[id_label].append(col)

    for i, l in enumerate(labeled_colors):
        if len(l) >= 2:
            l.sort(key=lambda c: c[2])
            labeled_colors[i] = [max(l[:len(l)/2], key=lambda c: c[1]),
                    max(l[len(l)/2:], key=lambda c: c[1])]

    rgb_colors = [hsl_to_rgb(col) for col in hue_selection]
    new_colors = rgb_colors[:]
    diff_contrast = 20
    i = 0
    while i < len(new_colors)-1:
        if contrast_norm(new_colors[i], new_colors[i+1]) < diff_contrast:
            new_colors.remove(new_colors[i+1])
        else:
            i += 1

    hex_colors = []
    for l in labeled_colors:
        for col in l:
            hex_colors.append(hsl_to_hex(col))

    hex_colors.append(hsl_to_hex(fgcolor))
    random.shuffle(hex_colors)
    hex_colors = [hsl_to_hex(bgcolor)] + hex_colors
    #for l in labeled_colors:
    #    for k, col in enumerate(l):
    #        rgb_col = hsl_to_rgb(col[0], col[1], col[2])
    #        print(str(i) + ". RGB : " + str(rgb_col) + " HSL : " + str(col) + ", contraste : " + str(contrast(rgb_col)))
    #        if len(l) >= 2:
    #            col2 = l[(k+1)%2]
    #            rgb_col2 = hsl_to_rgb(col2[0], col2[1], col2[2])
    #            print("L2 : " + str(color_dist(rgb_col, rgb_col2)))
    #        olddraw.rectangle([posx, 0, posx+swatchsize, swatchsize], fill=rgb_col)
    #        posx = posx + swatchsize
    #        i += 1
    #    print("")
    #    olddraw.rectangle([posx, 0, posx+swatchsize, swatchsize], fill=(0,0,0))
    #    posx = posx + swatchsize

    return hex_colors

def colors_to_file(colors, filename, resize=150, swatchsize=20):
    """ Creates a color palette and saves it to file """
    pal = Image.new('RGB', (swatchsize*len(colors) + 10, swatchsize))
    draw = ImageDraw.Draw(pal)

    posx = 0
    i = 1
    for col in colors:
        print(str(i) + ". RGB : " + str(col) + " contraste : " + str(contrast(col))
                + " NORM : " + str(color_dist(col, (0,0,0))))
        draw.rectangle([posx, 0, posx+swatchsize, swatchsize], fill=col)
        posx = posx + swatchsize
        i += 1

    del draw
    pal.save(filename, "PNG")

if __name__ == '__main__':
    colors = get_colors(sys.argv[1], 'new_palette_color.png', numcolors=200)
    for col in colors:
        print(col)
