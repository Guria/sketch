pub const css = "
import sketch as css
import sketch/size.{px}

pub fn card() {
  css.class([
    css.background(\"red\"),
    css.color(\"white\"),
    css.border_radius(px(8)),
  ])
}
"
