import gleam/io
import gleam/option.{None}
import gleam/string
import redraw
import redraw/attribute as a
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
  redraw.fragment([
    h.h1([], [h.text("Sketch")]),
    h.div([], [h.text("CSS-in-Gleam, made simple")]),
    h.div([], []),
    sh.div(section(), [], [
      h.h2([], [h.text("Sketch CSS")]),
      h.div([], [code_highlight(#(example_css.css))]),
    ]),
  ])
}

fn code_highlight() {
  use #(code) <- redraw.component_("CodeHighlight")
  let res = css.compute_modules([css.Module("example_css.gleam", code, None)])
  io.debug(res)
  let code = highlight(string.trim(code))
  h.code([a.dangerously_set_inner_html(a.inner_html(code))], [])
}

fn section() {
  sketch.class([
    sketch.background("red"),
    sketch.color("white"),
    sketch.border_radius(px(8)),
  ])
}
