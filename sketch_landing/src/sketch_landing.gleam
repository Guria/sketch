import gleam/io
import gleam/option.{None}
import gleam/string
import redraw
import redraw/attribute as a
import redraw/handler
import redraw/html as h
import redraw_dom/client
import sketch
import sketch/css
import sketch/redraw as sh
import sketch/size.{px}
import sketch_landing/example_css

@external(javascript, "./sketch_landing.ffi.mjs", "highlight")
fn highlight(code: String) -> String

pub fn main() {
  let app = app()
  let root = client.create_root("root")
  client.render(root, redraw.strict_mode([app()]))
}

fn app() {
  let code_highlight = code_highlight()
  use <- redraw.component__("App")
  let #(count, set_count) = redraw.use_state_(0)
  redraw.fragment([
    h.h1([], [h.text("Sketch")]),
    h.div([], [h.text("CSS-in-Gleam, made simple")]),
    h.div([], [
      h.button([handler.on_click(fn(_) { set_count(fn(c) { c + 1 }) })], [
        h.text("click me"),
      ]),
    ]),
    sh.div(section(count), [], [
      h.h2([], [h.text("Sketch CSS")]),
      h.div([], [code_highlight(#(example_css.css))]),
    ]),
  ])
}

fn code_highlight() {
  use #(code) <- redraw.component_("CodeHighlight")
  let res = css.compute_modules([css.Module("example_css.gleam", code, None)])
  // io.debug(res)
  let code = highlight(string.trim(code))
  h.code([a.dangerously_set_inner_html(a.inner_html(code))], [])
}

fn section(count: Int) {
  sketch.class([
    sketch.background(case count % 2 == 0 {
      True -> "red"
      False -> "red"
    }),
    sketch.color("white"),
    sketch.border_radius(px(8)),
  ])
}
