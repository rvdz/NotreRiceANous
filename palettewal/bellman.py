# Takes the colors and a predicate of type p(c1, c2) as arguments
def filter_colors(colors, predicate, norm):
    colors = list(set(colors))
    colors.sort(key=lambda l: norm(l))
    print("To filter: " + str([norm(c) for c in colors]))
    to_remove = filter_beaches(colors, [], predicate, norm)
    for color in to_remove:
        colors.remove(color)
    print("Filtered colors: " + str([norm(c) for c in colors]))
    return colors

def filter_beaches(colors, removed, predicate, norm):
    beaches = get_beaches(colors, predicate, norm)
    if not beaches:
        return removed
    all_removes = []
    for beach in beaches:
        all_removes.extend(filter_beach(beach, removed, predicate, norm))
    return all_removes

def filter_beach(beach, removed, predicate, norm):
    removed_sets = []
    for color in beach:
        new_colors = beach[:]
        new_colors.remove(color)
        new_removed = removed[:]
        new_removed.append(color)
        new_removed = list(set(new_removed))
        s = filter_beaches(new_colors, new_removed, predicate, norm)
        removed_sets.append(s)
    opt_removed = min(removed_sets, key=lambda l: len(l))
    return opt_removed

def get_beaches(colors, predicate, norm):
    beaches = []
    in_beach = False
    for i in range(len(colors) - 1):
        if predicate(colors[i + 1], colors[i]):
            if not beaches or not in_beach:
                beaches.append([colors[i], colors[i+1]])
            else:
                beaches[-1].append(colors[i+1])
            in_beach = True
        else:
            in_beach = False

    without_duplicates = []
    for beach in beaches:
        without_duplicates.append(list(set(beach)))
        without_duplicates[-1].sort(key=lambda l: norm(l))
    return without_duplicates

def norm(col):
    return col

def predicate(col1, col2):
    return abs(norm(col1) - norm(col2)) < 10

filter_colors([28, 87, 89, 94, 99, 120, 125, 146, 147, 151, 167], predicate, norm)
# filter_colors([120, 125, 146, 147, 151, 167], predicate, norm)
