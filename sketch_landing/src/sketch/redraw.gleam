import redraw
import redraw/html
import redraw/internals/attribute
import sketch

@external(javascript, "../sketch_redraw.ffi.mjs", "extract")
fn extract(props: a) -> #(String, sketch.Class, a)

@external(javascript, "../sketch_redraw.ffi.mjs", "addTag")
fn add_tag(props: a, tag: String) -> String

@external(javascript, "../sketch_redraw.ffi.mjs", "addStyles")
fn add_styles(props: a, styles: sketch.Class) -> String

@external(javascript, "../sketch_redraw.ffi.mjs", "addClassName")
fn add_class_name(props: a, class_name: String) -> String

fn do_styled(props) {
  let #(tag, styles, props) = extract(props)
  let #(cache, class_name) =
    redraw.use_memo(
      fn() {
        let assert Ok(cache) = sketch.cache(strategy: sketch.Ephemeral)
        styles |> sketch.class_name(cache)
      },
      #(styles.string_representation),
    )
  let props = add_class_name(props, class_name)
  redraw.fragment([
    html.style([], sketch.render(cache)),
    redraw.jsx(tag, props, Nil),
  ])
}

pub fn styled(tag: String, styles: sketch.Class, props, children) {
  attribute.to_props(props)
  |> add_tag(tag)
  |> add_styles(styles)
  |> redraw.jsx(do_styled, _, children)
}

pub fn div(styles, props, children) {
  styled("div", styles, props, children)
}
