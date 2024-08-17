import * as landing from './sketch_landing.gleam'
import gleamHljs from '@gleam-lang/highlight.js-gleam'
import hljs from 'highlight.js/lib/core'
import plaintext from 'highlight.js/lib/languages/plaintext'

hljs.registerLanguage('gleam', gleamHljs)
hljs.registerLanguage('plaintext', plaintext)
landing.main()
