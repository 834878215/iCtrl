#  Copyright (c) 2021-2022 iCtrl Developers
# 
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to
#   deal in the Software without restriction, including without limitation the
#   rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
#   sell copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
# 
#  The above copyright notice and this permission notice shall be included in
#   all copies or substantial portions of the Software.
# 
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
#   IN THE SOFTWARE.

from io import BytesIO

from PIL import Image, ImageDraw, ImageFont

from ..paths import FONT_PATH

# Ref: https://stackoverflow.com/questions/4014823/does-a-favicon-have-to-be-32%C3%9732-or-16%C3%9716
ICON_SIZE = 228

ICON_CIRCLE_POSITION = (14, 14, ICON_SIZE - 14, ICON_SIZE - 14)
ICON_RECTANGLE_POSITION = ((ICON_SIZE - 88, ICON_SIZE - 88), (ICON_SIZE, ICON_SIZE))
ICON_FONT = ImageFont.truetype(FONT_PATH, 64)


class Favicon:
    # Reference: https://next.material-ui.com/components/avatars/
    @staticmethod
    def text_to_color(text):
        text_hash = 0

        for char in text:
            text_hash = ord(char) + (text_hash << 5) - text_hash

        color_list = ['#']

        for i in range(3):
            value = (text_hash >> (i * 8)) & 0xff
            color_list.append(f'00{format(value, "x")}'[-2:])

        return ''.join(color_list)

    def __init__(self, host):
        if host.startswith('192'):
            self.short_text = host[-5:]
        else:
            self.short_text = host[:5]

        self.color = self.text_to_color(host)
        self.im = Image.new('RGBA', (ICON_SIZE, ICON_SIZE))
        self.draw = ImageDraw.Draw(self.im)

        self.draw.ellipse(ICON_CIRCLE_POSITION, fill=self.color)
        w, h = self.draw.textsize(self.short_text, font=ICON_FONT)
        self.draw.text(((ICON_SIZE - w) / 2, (ICON_SIZE - h) / 2), self.short_text, font=ICON_FONT)

    def vnc(self, temp):
        self.draw.rectangle(ICON_RECTANGLE_POSITION, fill='#f08080')
        self.im.save(temp, format='png')

    def console(self, temp):
        self.draw.rectangle(ICON_RECTANGLE_POSITION, fill='black')
        self.im.save(temp, format='png')

    def file_manager(self, temp):
        self.draw.rectangle(ICON_RECTANGLE_POSITION, fill='#1976d2')
        self.im.save(temp, format='png')

    @staticmethod
    def generate(host, feature):
        result = BytesIO()

        icon = Favicon(host)
        if feature == 'vnc':
            icon.vnc(result)
        elif feature == 'terminal':
            icon.console(result)
        elif feature == 'fm':
            icon.file_manager(result)
        else:
            raise ValueError(f"Invalid feature: {feature}")

        result.seek(0)

        return result
