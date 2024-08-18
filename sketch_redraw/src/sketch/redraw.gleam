import redraw.{type Component}
import redraw/attribute.{type Attribute} as a
import redraw/html
import redraw/internals/attribute
import sketch.{type Class}
import sketch/redraw/internals/mutable as mut
import sketch/redraw/internals/object

/// Extract the props generated from `styled` function.
/// Extract `as` and `styles`, and the new props without them.
@external(javascript, "../redraw.ffi.mjs", "extract")
fn extract(props: a) -> #(String, Class, a)

/// Creates the styled function from `do_styled` if it does not exists.
/// Otherwise, returns the existing `do_styled` function specialized for the tag.
@external(javascript, "../redraw.ffi.mjs", "styledFn")
fn styled_fn(tag: String, value: a) -> a

/// Unique name for Sketch Context. Only used across the module.
const context_name = "SketchRedrawContext"

/// Error message used when querying context. Should be used to indicate to the
/// user what should be done before using `sketch_redraw`.
const error_msg = "Sketch Redraw Provider not set. Please, set your provider"

/// Creates the Sketch provider used to manage Cache. This makes sure identical
/// styles will never be computed twice.
///
/// Use it at root of your render function.
/// ```gleam
/// import redraw_dom/client
/// import sketch/redraw as sketch_redraw
///
/// pub fn main() {
///   let app = app()
///   let root = client.create_root("root")
///   client.render(root, {
///     redraw.strict_mode([
///       sketch_redraw.provider([
///         app(),
///       ]),
///     ])
///   })
/// }
/// ```
pub fn provider(children) {
  let assert Ok(cache) = sketch.cache(strategy: sketch.Ephemeral)
  let cache = mut.wrap(cache)
  let assert Ok(context) = redraw.context(context_name, cache)
  redraw.provider(context, cache, children)
}

fn get_context() {
  case redraw.get_context(context_name) {
    Ok(context) -> context
    Error(_) -> panic as error_msg
  }
}

fn do_styled(props) {
  let context = get_context()
  let cache: mut.Mutable(sketch.Cache) = redraw.use_context(context)
  let #(tag, styles, props) = extract(props)
  let deps = #(styles.string_representation)
  let #(cache_, class_name) =
    redraw.use_memo(fn() { sketch.class_name(styles, mut.get(cache)) }, deps)
  let style = sketch.render(mut.get(mut.set(cache, cache_)))
  redraw.fragment([
    html.style([], style),
    redraw.jsx(tag, object.add(props, "className", class_name), Nil),
  ])
}

pub fn styled(
  tag: String,
  styles: Class,
  props: List(Attribute),
  children: List(Component),
) {
  let as_ = a.attribute("as", tag)
  let styles = a.attribute("styles", styles)
  let fun = styled_fn(tag, do_styled)
  attribute.to_props([as_, styles, ..props])
  |> redraw.jsx(fun, _, children)
}
