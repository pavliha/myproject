pragma Singleton
import QtQuick 2.15
import MyProject 1.0

QtObject {
    // Use the darkMode property from the C++ ThemeChecker singleton.
    readonly property bool isDark: ThemeChecker.darkMode
    // A convenience property that returns a string "dark" or "light"
    readonly property string mode: isDark ? "dark" : "light"

    // Helper function to convert HSL values (0-360, 0-100, 0-100) to an RGBA color.
    function hslToRgb(h, s, l) {
        h = h / 360;
        s = s / 100;
        l = l / 100;

        let r, g, b;
        if (s === 0) {
            r = g = b = l;
        } else {
            function hue2rgb(p, q, t) {
                if (t < 0)
                    t += 1;
                if (t > 1)
                    t -= 1;
                if (t < 1 / 6)
                    return p + (q - p) * 6 * t;
                if (t < 1 / 2)
                    return q;
                if (t < 2 / 3)
                    return p + (q - p) * (2 / 3 - t) * 6;
                return p;
            }
            const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
            const p = 2 * l - q;
            r = hue2rgb(p, q, h + 1 / 3);
            g = hue2rgb(p, q, h);
            b = hue2rgb(p, q, h - 1 / 3);
        }
        return Qt.rgba(r, g, b, 1.0);
    }

    // Light theme colors
    readonly property color _lightBackground: hslToRgb(0, 0, 100)
    readonly property color _lightForeground: hslToRgb(222.2, 47.4, 11.2)
    readonly property color _lightCard: hslToRgb(0, 0, 100)
    readonly property color _lightCardForeground: hslToRgb(222.2, 47.4, 11.2)
    readonly property color _lightBorder: hslToRgb(214.3, 31.8, 91.4)
    readonly property color _lightMutedForeground: hslToRgb(215.4, 16.3, 46.9)

    // Dark theme colors
    readonly property color _darkBackground: hslToRgb(0, 0, 0)
    readonly property color _darkForeground: hslToRgb(210, 40, 98)
    readonly property color _darkCard: hslToRgb(222.2, 84, 4.9)
    readonly property color _darkCardForeground: hslToRgb(210, 40, 98)
    readonly property color _darkBorder: hslToRgb(217.2, 32.6, 17.5)
    readonly property color _darkMutedForeground: hslToRgb(215, 20.2, 65.1)

    // Dynamic colors based on theme
    readonly property color background: isDark ? _darkBackground : _lightBackground
    readonly property color foreground: isDark ? _darkForeground : _lightForeground
    readonly property color card: isDark ? _darkCard : _lightCard
    readonly property color cardForeground: isDark ? _darkCardForeground : _lightCardForeground
    readonly property color border: isDark ? _darkBorder : _lightBorder
    readonly property color mutedForeground: isDark ? _darkMutedForeground : _lightMutedForeground

    // Additional colors (adjust HSL values as needed)
    readonly property color primary: isDark ? hslToRgb(210, 40, 98) : hslToRgb(222.2, 47.4, 11.2)
    readonly property color primaryForeground: isDark ? hslToRgb(222.2, 47.4, 11.2) : hslToRgb(210, 40, 98)
    readonly property color destructive: isDark ? hslToRgb(0, 62.8, 30.6) : hslToRgb(0, 100, 50)
    readonly property color destructiveForeground: isDark ? hslToRgb(210, 40, 98) : hslToRgb(210, 40, 98)
    readonly property color accent: isDark ? hslToRgb(217.2, 32.6, 17.5) : hslToRgb(210, 40, 96.1)
    readonly property color accentForeground: isDark ? hslToRgb(210, 40, 98) : hslToRgb(222.2, 47.4, 11.2)
    readonly property color secondary: isDark ? hslToRgb(217.2, 32.6, 17.5) : hslToRgb(210, 40, 96.1)
    readonly property color secondaryForeground: isDark ? hslToRgb(210, 40, 98) : hslToRgb(222.2, 47.4, 11.2)
    readonly property color ring: isDark ? hslToRgb(212.7, 26.8, 83.9) : hslToRgb(222.2, 84, 4.9)
    readonly property color input: isDark ? hslToRgb(217.2, 32.6, 17.5) : hslToRgb(214.3, 31.8, 91.4)

    // Spacing matching Shadcn design system
    readonly property QtObject spacing: QtObject {
        readonly property int xs: 8    // space-2: 0.5rem
        readonly property int sm: 12   // space-3: 0.75rem
        readonly property int md: 16   // space-4: 1rem
        readonly property int lg: 24   // space-6: 1.5rem
        readonly property int xl: 32   // space-8: 2rem
        readonly property int xxl: 48  // space-12: 3rem
        readonly property int xxxl: 64 // space-16: 4rem
    }

    // Border radius matching Tailwind config
    readonly property real radius: 8  // 0.5rem

    // withAlpha function: returns the given color with the specified alpha value.
    function withAlpha(color, alpha) {
        if (!color)
            return Qt.rgba(0, 0, 0, alpha);
        if (color === "transparent")
            return color;
        // If color has r, g, b properties
        if (color.r !== undefined && color.g !== undefined && color.b !== undefined) {
            return Qt.rgba(color.r, color.g, color.b, alpha);
        }
        // Handle hex strings (e.g. "#RRGGBB")
        if (typeof color === 'string' && color.startsWith('#')) {
            const r = parseInt(color.substr(1, 2), 16) / 255;
            const g = parseInt(color.substr(3, 2), 16) / 255;
            const b = parseInt(color.substr(5, 2), 16) / 255;
            return Qt.rgba(r, g, b, alpha);
        }

        // If we can't process the color, return it unchanged
        return color;
    }
}
