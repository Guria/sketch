const styledFns = {}

export function styledFn(tag, defaultValue) {
  if (styledFns[tag]) return styledFns[tag]
  let value = defaultValue.bind({})
  value.displayName = `Sketch.Styled(${tag})`
  styledFns[tag] ??= value
  return value
}

export function extract(props) {
  const { styles, as, ...props_ } = props
  return [as, styles, props_]
}

export function assign(props, fieldName, value) {
  return { ...props, [fieldName]: value }
}
