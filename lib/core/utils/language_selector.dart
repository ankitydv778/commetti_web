import 'package:committee/core/constants/app_colors.dart';
import 'package:committee/providers/language_provider.dart';
import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  final LanguageProvider languageProvider;

  const LanguageSelector({required this.languageProvider});

  @override
  State<LanguageSelector> createState() => LanguageSelectorState();
}

class LanguageSelectorState extends State<LanguageSelector>
    with SingleTickerProviderStateMixin {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _controller.reverse().then((_) => _removeOverlay());
    } else {
      _showOverlay();
      _controller.forward();
    }

    setState(() => _isOpen = !_isOpen);
  }

  void _showOverlay() {
    final renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _toggleDropdown,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 8,
              width: 220,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 30,
                            spreadRadius: 2,
                            color: Colors.black.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget
                            .languageProvider
                            .supportedLanguages
                            .entries
                            .map((entry) {
                              final isSelected = widget.languageProvider
                                  .isCurrentLanguage(entry.key);

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  widget.languageProvider.changeLanguage(
                                    entry.key,
                                  );
                                  _toggleDropdown();
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryColor.withOpacity(
                                            0.08,
                                          )
                                        : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.languageProvider.getFlagEmoji(
                                          entry.key,
                                        ),
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Text(
                                          entry.value,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: isSelected
                                                ? AppColors.primaryColor
                                                : Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.dark
                                                ? Colors.white70
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle,
                                          size: 18,
                                          color: AppColors.primaryColor,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        key: _buttonKey,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [Colors.grey.shade800, Colors.grey.shade700]
                : [Colors.grey.shade100, Colors.grey.shade200],
          ),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.08)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.languageProvider.currentFlagEmoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Text(
              widget.languageProvider.currentLanguageName.substring(0, 3),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 6),
            AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: _isOpen ? 0.5 : 0,
              child: const Icon(
                Icons.expand_more,
                size: 18,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
