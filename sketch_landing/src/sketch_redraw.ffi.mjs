import { memo, useMemo, Fragment } from 'react'
import { jsxs, jsx } from 'react/jsx-runtime'
import * as internals from './sketch/internals/redraw.mjs'

export function addTag(props, as) {
  return { ...props, as }
}

export function addStyles(props, styles) {
  return {...props, styles}
}

export function extract(props) {
  const { styles, as, ...props_ } = props
  return [as, styles, props_]
}

export function addClassName(props, className) {
  return { ...props, className }
}

function arePropsEqual(a, b) {
  if (!a.styles) return false
  if (!b.styles) return false
  const { styles: aStyles, ...aProps } = a
  const { styles: bStyles, ...bProps } = b
  if (aStyles.string_representation !== bStyles.string_representation)
    return false
  const aKeys = Object.keys(aProps)
  const bKeys = Object.keys(bProps)
  if (aKeys.length !== bKeys.length) return false
  for (const prop of aKeys) {
    if (!Object.is(aProps[prop], bProps[prop])) {
      return false
    }
  }
  return true
}

export const Styled = memo(props => {
  console.log('Styled')
  const [as, styles, props_] = extract(props)
  const [cache, className] = useMemo(() => {
    const cache = internals.cache(internals.ephemeral)[0]
    const result = internals.class_name(styles, cache)
    return result
  }, [styles.string_representation])
  const strStyles = internals.render(cache)
  props_.className = className
  return jsxs(Fragment, {children: [
    jsx('style', { children: strStyles }),
    jsx(as, props_)
  ]})
}, arePropsEqual)
