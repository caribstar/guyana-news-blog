# -*- coding: utf-8 -*-
import os
import codecs

os.chdir(r'C:/Users/Staff/guyana-news-blog/content/posts')

files = ['2026-01-08-thursday-brief.md', '2026-01-09-friday-brief.md', '2026-01-10-saturday-brief.md']

for filename in files:
    # Read file
    with open(filename, 'rb') as f:
        data = f.read()
    
    # Decode as UTF-8
    try:
        text = data.decode('utf-8')
    except:
        text = data.decode('utf-8', errors='replace')
    
    # Replace broken mojibake with proper emojis using raw strings
    text = text.replace('\u00f0\u009f\u0087\u00ac\u00f0\u009f\u0087\u00be', '\U0001F1EC\U0001F1FE')  # Guyana flag
    text = text.replace('\u00f0\u009f\u0093\u008a', '\U0001F4CA')  # Chart
    text = text.replace('\u00f0\u009f\u0092\u00af', '\U0001F4AF')  # 100
    text = text.replace('\u00f0\u009f\u0094\u00a5', '\U0001F525')  # Fire
    text = text.replace('\u00e2\u009a\u00b0\u00ef\u00b8\u008f', '\U000026B0\U0000FE0F')  # Coffin
    text = text.replace('\u00f0\u009f\u008e\u00ad', '\U0001F3AD')  # Theater
    text = text.replace('\u00f0\u009f\u008e\u00ac', '\U0001F3AC')  # Movie
    text = text.replace('\u00f0\u009f\u0093\u00b9', '\U0001F4F9')  # Video
    text = text.replace('\u00e2\u009c\u0085', '\U00002705')  # Check
    text = text.replace('\u00e2\u00ad', '\U00002B50')  # Star
    text = text.replace('\u00e2\u009a\u00a0', '\U000026A0\U0000FE0F')  # Warning
    text = text.replace('\u00e2\u008f\u00b1\u00ef\u00b8\u008f', '\U000023F1\U0000FE0F')  # Stopwatch
    
    # Write back with UTF-8
    with open(filename, 'wb') as f:
        f.write(text.encode('utf-8'))
    
    print(f'Fixed: {filename}')

print('')
print('All files fixed! Now run:')
print('git add content/posts/*.md')
print('git commit -m \"Fix emoji encoding\"')
print('git push origin main')
