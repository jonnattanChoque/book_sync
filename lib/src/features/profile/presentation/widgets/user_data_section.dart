import 'dart:io';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/widgets/cozy_toast.dart';
import 'package:book_sync/core/widgets/custom_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class UserDataSection extends ConsumerStatefulWidget {
  const UserDataSection({super.key});

  @override
  ConsumerState<UserDataSection> createState() => _UserDataSectionState();
}

class _UserDataSectionState extends ConsumerState<UserDataSection> {
  late final TextEditingController _nameController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final settings = ref.read(appSettingsProvider);
    _nameController = TextEditingController(text: settings.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveData() {
    ref.read(appSettingsProvider.notifier).updateUserData(
      name: _nameController.text.trim(),
    );
    FocusScope.of(context).unfocus();
    CozyToast.showSuccess(
      context,
      title: context.l10n.nameSavedSuccess,
      icon: Icons.person_outline,
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (image != null) {
        await ref.read(appSettingsProvider.notifier).updateUserData(
          name: _nameController.text.trim(),
          profileImagePath: image.path,
        );
        CozyToast.showSuccess(
          context,
          title: context.l10n.imageSavedSuccess,
          icon: Icons.image_outlined,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.imageSelectionError(e.toString(),))),
        );
      }
    }
  }

  void _showImageSourceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(context.l10n.chooseFromGallery),
                onTap: () {
                  Navigator.pop(modalContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(context.l10n.takePhotoWithCamera),
                onTap: () {
                  Navigator.pop(modalContext);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final cozy = context.cozy;
    final settings = ref.watch(appSettingsProvider);
    final profileImagePath = settings.profileImagePath;
    final String? imagePath = profileImagePath;
    final bool hasImage = imagePath != null && imagePath.isNotEmpty;
    final bool isNetworkImage = hasImage && (imagePath.startsWith('http://') || imagePath.startsWith('https://'));
    final isPremium = settings.isPremium;

    // 2. Determinar el ImageProvider adecuado
    ImageProvider? getImageProvider() {
      if (!hasImage) return null;
      if (isNetworkImage) {
        return NetworkImage(imagePath);
      }
      return FileImage(File(imagePath));
    }

    ref.listen(appSettingsProvider, (previous, next) {
      if (previous?.userName != next.userName && _nameController.text != next.userName) {
        _nameController.text = next.userName;
      }
    });
    
    return CustomInfoCardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPremium ?? false)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        context.l10n.proPremiumBadge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    final title = context.l10n.paywallProfileTitle;
                    context.push('/premium', extra: title);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          context.l10n.upgradeToPremium,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
                
            ],
          ),
          SizedBox(height: 12,),
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 20,
                color: cozy.bookmarkColor,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.userDataSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: cozy.bookmarkColor?.withValues(alpha: 0.2),
                  backgroundImage: getImageProvider(),
                  child: !hasImage
                  ? Text(
                      _nameController.text.isNotEmpty
                      ? _nameController.text[0].toUpperCase()
                      : 'U',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: cozy.inkColor,
                      ),
                    )
                  : null,
                ),
                Positioned(
                  width: 32,
                  height: 32,
                  bottom: 0,
                  right: 0,
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.camera_alt, size: 12),
                    onPressed: () => _showImageSourceModal(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.nameLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            onEditingComplete: () => _saveData(),
            onTapOutside: (_) => _saveData(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: cozy.inkColor!.withValues(alpha: 0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: cozy.inkColor!.withValues(alpha: 0.8),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}