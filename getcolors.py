from PIL import Image, ImageDraw
import colorsys
import subprocess as sp
import re
from ast import literal_eval as make_tuple

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
    print([re.search("#.{6}", str(col)).group(0) for col in raw_colors])
    magic_colors = [re.search("rgb\(.*\)", str(col)).group(0)[3:] for col in raw_colors]
    magic_colors = [make_tuple(rgb_col) for rgb_col in magic_colors]
    print(magic_colors)

    hls_colors = [colorsys.rgb_to_hls(col[0], col[1], col[2]) for col in magic_colors]

    # Sort colors by lightness
    hls_colors.sort(key=lambda tup: tup[0])

    # Save colors to file
    pal = Image.new('RGB', (swatchsize*numcolors, swatchsize))
    draw = ImageDraw.Draw(pal)

    # Minimum lightness
    min_lightness = 0.30 * 255

    bgcolor = hls_colors[0]
    fgcolor = hls_colors[-1]
    hls_colors = [tup for tup in hls_colors if tup[1] > min_lightness]
    #print(len(hls_colors))
    hue_step = 30
    hue_selection = []
    for i in range(0, 360/hue_step):
        tmp = [col for col in hls_colors if 360*col[0] >= hue_step*i and 360*col[0] <= hue_step*(i+1)]
        if tmp:
            hue_selection.append(tmp[0])
            hls_colors.remove(tmp[0])

    #hue_selection.append(hls_colors[-1])

    posx = 0
    for col in hue_selection:
        colrgb = colorsys.hls_to_rgb(col[0], col[1], col[2])
        colrgb = (int(colrgb[0]), int(colrgb[1]), int(colrgb[2]))
        #print(str(colrgb) + "lightness : {}".format(col[1]))
        draw.rectangle([posx, 0, posx+swatchsize, swatchsize], fill=colrgb)
        posx = posx + swatchsize

    print(hls_colors)

    del draw
    pal.save(outfile, "PNG")

if __name__ == '__main__':
    get_colors('wallpapers/tapei.jpg', 'selectoutcolors.png', numcolors=300)
