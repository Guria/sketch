import redraw
import redraw/attribute as a
import redraw/internals/attribute
import sketch

// @external(javascript, "../sketch_redraw.ffi.mjs", "addTag")
// fn add_tag(props: a, tag: String) -> String

// @external(javascript, "../sketch_redraw.ffi.mjs", "addStyles")
// fn add_styles(props: a, styles: sketch.Class) -> String

@external(javascript, "../sketch_redraw.ffi.mjs", "Styled")
fn do_styled(a: a) -> a

pub fn styled(tag: String, styles: sketch.Class, props, children) {
  attribute.to_props([
    a.attribute("styles", styles),
    a.attribute("as", tag),
    ..props
  ])
  // |> add_tag(tag)
  // |> add_styles(styles)
  |> redraw.jsx(do_styled, _, children)
}

pub fn div(styles, props, children) {
  styled("div", styles, props, children)
}
