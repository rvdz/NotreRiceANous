from functools import partial

# Takes the colors and a predicate of type p(c1, c2) as arguments
# Requires: colors must not contain duplicates
def filter_colors(colors, predicate):
    list(set(colors)).sort()
    print("To filter: " + str(colors))
    to_remove = filter_beaches(colors, [], predicate)
    for color in to_remove:
        colors.remove(color)
    return colors

def get_beaches(colors, predicate):
    beaches = []
    in_beach = False
    for i in range(len(colors) - 1):
        if predicate(colors[i + 1], colors[i]):
            if not beaches or not in_beach:
                beaches.append([colors[i], colors[i+1]])
                in_beach = True
            else:
                beaches[-1].append(colors[i+1])
        else:
            in_beach = False

    without_duplicates = []
    for beach in beaches:
        without_duplicates.append(list(set(beach)))
        without_duplicates[-1].sort()
    return without_duplicates

def filter_beaches(colors, removed, predicate):
    beaches = get_beaches(colors, predicate)
    all_removes = removed[:]
    for beach in beaches:
        all_removes.extend(filter_beach(beach, removed[:], predicate))
    return all_removes

def filter_beach(beach, removed, predicate):
    removed_sets = []
    for color in beach:
        new_colors = beach[:]
        new_colors.remove(color)
        new_removed = removed[:]
        new_removed.append(color)
        removed_sets.append(filter_beaches(new_colors, new_removed, predicate))
    sort_sets = []
    for s in removed_sets:
        res = list(set(s))
        res.sort()
        sort_sets.append(res)
    return min(sort_sets, key=lambda l: len(l))
