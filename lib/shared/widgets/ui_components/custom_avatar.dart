import 'package:flutter/material.dart';

enum AvatarSize { small, medium, large, extraLarge }
enum AvatarShape { circle, rounded }

class CustomAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final IconData? icon;
  final AvatarSize size;
  final AvatarShape shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? badge;
  final VoidCallback? onTap;
  
  const CustomAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.icon,
    this.size = AvatarSize.medium,
    this.shape = AvatarShape.circle,
    this.backgroundColor,
    this.foregroundColor,
    this.badge,
    this.onTap,
  }) : assert(
    imageUrl != null || name != null || icon != null,
    'Either imageUrl, name, or icon must be provided',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = _getRadius();
    final fontSize = _getFontSize();
    
    Widget avatar = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundColor ?? _generateColor(name),
        shape: shape == AvatarShape.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape == AvatarShape.rounded 
            ? BorderRadius.circular(radius * 0.3)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(theme, fontSize),
    );
    
    if (badge != null) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: badge!,
          ),
        ],
      );
    }
    
    if (onTap != null) {
      avatar = InkWell(
        onTap: onTap,
        borderRadius: shape == AvatarShape.circle
            ? BorderRadius.circular(radius)
            : BorderRadius.circular(radius * 0.3),
        child: avatar,
      );
    }
    
    return avatar;
  }
  
  Widget _buildContent(ThemeData theme, double fontSize) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallback(theme, fontSize),
      );
    }
    
    return _buildFallback(theme, fontSize);
  }
  
  Widget _buildFallback(ThemeData theme, double fontSize) {
    if (icon != null) {
      return Icon(
        icon,
        size: fontSize * 1.5,
        color: foregroundColor ?? theme.colorScheme.onPrimaryContainer,
      );
    }
    
    if (name != null && name!.isNotEmpty) {
      final initials = _getInitials(name!);
      return Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: foregroundColor ?? theme.colorScheme.onPrimaryContainer,
          ),
        ),
      );
    }
    
    return Icon(
      Icons.person,
      size: fontSize * 1.5,
      color: foregroundColor ?? theme.colorScheme.onPrimaryContainer,
    );
  }
  
  double _getRadius() {
    return switch (size) {
      AvatarSize.small => 16,
      AvatarSize.medium => 24,
      AvatarSize.large => 40,
      AvatarSize.extraLarge => 60,
    };
  }
  
  double _getFontSize() {
    return switch (size) {
      AvatarSize.small => 12,
      AvatarSize.medium => 16,
      AvatarSize.large => 24,
      AvatarSize.extraLarge => 32,
    };
  }
  
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first.substring(0, 1).toUpperCase();
  }
  
  Color _generateColor(String? name) {
    if (name == null || name.isEmpty) {
      return Colors.grey;
    }
    
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
    ];
    
    final hash = name.hashCode;
    return colors[hash.abs() % colors.length];
  }
}