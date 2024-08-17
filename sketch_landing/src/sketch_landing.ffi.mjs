import hljs from 'highlight.js/lib/core'

export function highlight(code) {
  const highlighted = hljs.highlightAuto(code)
  return highlighted.value
}
