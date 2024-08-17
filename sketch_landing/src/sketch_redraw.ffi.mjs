import * as gleam from './gleam.mjs'

const styledFns = {}

export function getStyledFn(tag) {
  const value = styledFns[tag]
  if (!value) return new gleam.Error(null)
  return new gleam.Ok(value)
}

export function setStyledFn(tag, value) {
  let val = value.bind({})
  val.displayName = `Sketch.Styled(${tag})`
  styledFns[tag] ??= val
  return val
}

export function extract(props) {
  const { styles, as, ...props_ } = props
  return [as, styles, props_]
}

export function addClassName(props, className) {
  return { ...props, className }
}

export function wrap(current) {
  return { current }
}

export function set(variable, newValue) {
  variable.current = newValue
  return variable
}

export function get(variable) {
  return variable.current
}
