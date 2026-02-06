class ImageOption {
  final String name; // 名称
  final String src; // 资源
  final int min; // 每次点击时功德最小值
  final int max; // 每次点击时功德最大值

  const ImageOption({
    required this.name,
    required this.src,
    required this.min,
    required this.max,
  });
}
