import gleam/result
import redraw
import redraw/attribute as a
import redraw/html
import redraw/internals/attribute
import sketch

pub type Mutable(a)

@external(javascript, "../sketch_redraw.ffi.mjs", "wrap")
fn wrap(mut: a) -> Mutable(a)

@external(javascript, "../sketch_redraw.ffi.mjs", "set")
fn set(mut: Mutable(a), value: a) -> Mutable(a)

@external(javascript, "../sketch_redraw.ffi.mjs", "get")
fn get(mut: Mutable(a)) -> a

@external(javascript, "../sketch_redraw.ffi.mjs", "extract")
fn extract(props: a) -> #(String, sketch.Class, a)

@external(javascript, "../sketch_redraw.ffi.mjs", "addClassName")
fn add_class_name(props: a, class_name: String) -> String

@external(javascript, "../sketch_redraw.ffi.mjs", "getStyledFn")
fn get_styled_fn(tag: String) -> Result(a, Nil)

@external(javascript, "../sketch_redraw.ffi.mjs", "setStyledFn")
fn set_styled_fn(tag: String, value: a) -> a

const context_name = "SketchRedrawContext"

pub fn provider(children) {
  let assert Ok(cache) = sketch.cache(strategy: sketch.Ephemeral)
  let cache = wrap(cache)
  let assert Ok(context) = redraw.context(context_name, cache)
  redraw.provider(context, cache, children)
}

pub fn do_styled(props) {
  let context = case redraw.get_context(context_name) {
    Ok(context) -> context
    Error(_) ->
      panic as "Sketch Redraw Provider not set. Please, set your provider"
  }
  let cache: Mutable(sketch.Cache) = redraw.use_context(context)
  let #(tag, styles, props) = extract(props)
  let deps = #(styles.string_representation)
  let #(cache_, class_name) =
    redraw.use_memo(fn() { sketch.class_name(styles, get(cache)) }, deps)
  set(cache, cache_)
  let props = add_class_name(props, class_name)
  redraw.fragment([
    html.style([], sketch.render(get(cache))),
    redraw.jsx(tag, props, Nil),
  ])
}

pub fn styled(tag: String, styles: sketch.Class, props, children) {
  let as_ = a.attribute("as", tag)
  let styles = a.attribute("styles", styles)
  let fun =
    get_styled_fn(tag)
    |> result.unwrap(set_styled_fn(tag, do_styled))
  attribute.to_props([as_, styles, ..props])
  |> redraw.jsx(fun, _, children)
}

pub fn div(styles, props, children) {
  styled("div", styles, props, children)
}

pub fn button(styles, props, children) {
  styled("button", styles, props, children)
}
