#!/usr/bin/env bash
set -eu

# Prefix relative paths so names beginning with '-' cannot become options.
path=$1
[[ $path = /* ]] || path=./$path
mime=$(file --brief --mime-type --dereference -- "$path")

case "$mime" in
    image/*)
        # Television 0.15 renders ANSI text, not terminal graphics protocols.
        # It does not pass preview dimensions; use a bounded, scrollable image.
        exec chafa --format=symbols --colors=full --size=60x24 \
            --animate=off --probe=off --polite=on --optimize=0 -- "$path"
        ;;
    application/pdf)
        printf 'PDF — text from the first 10 pages (scans require OCR)\n\n'
        pdftotext -f 1 -l 10 -layout "$path" -
        ;;
    audio/*|video/*|application/ogg)
        exec ffprobe -v error -show_entries \
            'format=format_name,duration,size,bit_rate:format_tags:stream=codec_type,codec_name,width,height,sample_rate,channels:stream_tags' \
            -of default=noprint_wrappers=1 "$path"
        ;;
    application/x-7z-compressed|application/x-rar|application/vnd.rar)
        exec 7z l -p- -- "$path"
        ;;
    application/zip|application/x-tar|application/gzip|application/x-gzip|application/x-bzip2|application/x-xz|application/zstd|application/x-zstd)
        exec bsdtar -tvf "$path"
        ;;
    text/*|application/json|application/*+json|application/xml|application/*+xml|application/javascript|application/x-shellscript|inode/x-empty)
        exec bat --paging=never -n --color=always -- "$path"
        ;;
    *)
        exec file --brief --dereference -- "$path"
        ;;
esac
