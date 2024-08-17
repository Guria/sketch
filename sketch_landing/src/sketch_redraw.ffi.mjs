export function addTag(props, tag) {
  console.log('addTag, props:', props, 'tag:', tag)
  return props
}

export function addStyles(props, styles) {
  const __prototype = Object.getPrototypeOf(styles)
  const style_str = styles.string_representation
  const style_content = styles.content
  return {...props, __prototype, style_str, style_content}
}

export function extract(props) {
  const { __prototype, style_str, style_content, ...props_ } = props
  const styles = new __prototype.constructor(style_str, style_content)
  return ['div', styles, props_]
}

export function addClassName(props, className) {
  return { ...props, className }
}
