import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ccvc_mobile/widgets/image_gallery/widgets/camera_photo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';

Future<File?> showImagePicker(BuildContext context) {
  return showModalBottomSheet<File?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _Buider());
}

class _Buider extends StatefulWidget {
  const _Buider({Key? key}) : super(key: key);

  @override
  _BuiderState createState() => _BuiderState();
}

class _BuiderState extends State<_Buider> {
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  final int _sizePerPage = 50;

  AssetPathEntity? _path;
  List<AssetEntity>? _entities;
  int _totalEntitiesCount = 0;

  int _page = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreToLoad = true;
  Future<void> _requestAssets() async {
    setState(() {
      _isLoading = true;
    });
    // Request permissions.
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) {
      return;
    }
    // Further requests can be only procceed with authorized or limited.
    if (ps != PermissionState.authorized && ps != PermissionState.limited) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    // Obtain assets using the path entity.
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      filterOption: _filterOptionGroup,
    );

    if (!mounted) {
      return;
    }
    // Return if not paths found.
    if (paths.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    setState(() {
      _path = paths.first;
    });
    _totalEntitiesCount = _path!.assetCount;
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities = entities;
      _isLoading = false;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
    });
  }

  Future<void> _loadMoreAsset() async {
    final List<AssetEntity> entities = await _path!.getAssetListPaged(
      page: _page + 1,
      size: _sizePerPage,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _entities!.addAll(entities);
      _page++;
      _hasMoreToLoad = _entities!.length < _totalEntitiesCount;
      _isLoadingMore = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestAssets();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        builder: (context, _) => Container(
              color: Colors.white,
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                itemCount: (_entities?.length ?? 0) + 1,
                itemBuilder: (BuildContext context, int index) {
                  int indexRemove = index;
                  if (index != 0) {
                    indexRemove = indexRemove - 1;
                  }
                  if (indexRemove == (_entities?.length ?? 0) - 8 &&
                      !_isLoadingMore &&
                      _hasMoreToLoad) {
                    _loadMoreAsset();
                  }
                  if(_entities == null){
                    return const SizedBox();
                  }
                  final AssetEntity entity = _entities![indexRemove];
                  return index == 0
                      ? CameraPhotoWidget(
                          onChange: (value) {
                            Navigator.pop(context, File(value.path));
                          },
                        )
                      : ImageItemWidget(
                    onTap: () async {
                      final file = await entity.file;
                      Navigator.pop(context,file);
                    },
                          key: ValueKey<int>(index),
                          entity: entity,
                          option: const ThumbnailOption(
                              size: ThumbnailSize.square(200)),
                        );
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count(1, index == 0 ? 2 : 1),
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
              ),
            ));
  }
}

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({
    Key? key,
    required this.entity,
    required this.option,
    this.onTap,
  }) : super(key: key);

  final AssetEntity entity;
  final ThumbnailOption option;
  final GestureTapCallback? onTap;

  Widget buildContent(BuildContext context) {
    if (entity.type == AssetType.audio) {
      return const Center(
        child: Icon(Icons.audiotrack, size: 30),
      );
    }
    return _buildImageWidget(entity, option);
  }

  Widget _buildImageWidget(AssetEntity entity, ThumbnailOption option) {
    return AssetEntityImage(
      entity,
      isOriginal: false,
      thumbnailSize: option.size,
      thumbnailFormat: option.format,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: buildContent(context),
    );
  }
}
