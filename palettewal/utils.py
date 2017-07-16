# Require RGB format
def color_dist(col1, col2):
    return ((col1[0]-col2[0])**2 + (col1[1]-col2[1])**2 + (col1[2]-col2[2])**2)**(0.5)

# Requires RGB format
def contrast(color):
    return (299*color[0] + 587*color[1] + 114*color[2]) / 1000

def contrast_norm(col1, col2):
    return abs(contrast(col1) - contrast(col2))

# Requires RGB format
def luminance(col):
    a = []
    for val in col:
        factor = val/255.
        if factor <= 0.03928:
            factor = factor/12.92
        else:
            factor = ((factor + 0.055)/1.055)**(2.4)
        a.append(factor)
    return a[0]*0.2126 + a[1]*0.7152 + a[2]*0.0722 + 0.05

def contrast_luminance(col1, col2):
    l1, l2 = luminance(col1), luminance(col2)
    return l1/l2 if l1 > l2 else l2/l1
