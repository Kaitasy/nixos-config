SIZE_UNITS = ["B", "KiB", "MiB", "GiB", "TiB"]


def bytes_to_human_readable(b: int) -> str:
    unit = 0
    n = b * 1.0
    while n > 1024:
        n /= 1024
        unit += 1

    return f"{n:.1f}{SIZE_UNITS[unit]}"
