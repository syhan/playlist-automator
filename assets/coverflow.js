/* Cover Flow —— 像 iPod 那样一期一期翻着挑日子
 * 数据直接从马赛克墙上取，不额外传一份 JSON；
 * 只给视口附近的十几张设 transform，其余 display:none，
 * 所以 900+ 期也不卡。 */
(function () {
  'use strict'

  var wall = document.getElementById('wall')
  var flow = document.getElementById('flow')
  var stage = document.getElementById('cf-stage')
  if (!wall || !flow || !stage) return

  var rangeEl = document.getElementById('cf-range')
  var elDate = document.getElementById('cf-date')
  var elTitle = document.getElementById('cf-title')
  var elAuthor = document.getElementById('cf-author')
  var elOpen = document.getElementById('cf-open')
  var btnPrev = document.getElementById('cf-prev')
  var btnNext = document.getElementById('cf-next')
  var btnRand = document.getElementById('cf-rand')
  var btnsView = [].slice.call(document.querySelectorAll('.views button'))
  var btnsSize = [].slice.call(document.querySelectorAll('.zoom button'))

  var KEY = 'fm896.'
  function get(k) { try { return localStorage.getItem(KEY + k) } catch (e) { return null } }
  function set(k, v) { try { localStorage.setItem(KEY + k, v) } catch (e) {} }

  /* ---------- 从墙上收集每一期 ---------- */
  var days = [].map.call(wall.querySelectorAll('.tile'), function (a) {
    var img = a.querySelector('img')
    var meta = a.querySelector('.meta')
    var author = meta && meta.querySelector('em')
    return {
      href: a.getAttribute('href'),
      thumb: img ? img.getAttribute('src') : '',
      full: img ? img.getAttribute('src').replace('/images/thumbs/', '/images/') : '',
      date: meta ? meta.querySelector('b').textContent.trim() : '',
      title: meta ? meta.querySelector('i').textContent.trim() : '',
      author: author ? author.textContent.trim() : ''
    }
  })
  if (!days.length) return

  /* ---------- 瓦片池（首次打开才建） ---------- */
  var R = 6           // 中心两侧各放几张
  var els = null
  var active = 0      // 0 = 最新一期
  var shownLo = -1
  var shownHi = -1
  var tileSize = 300
  var spread = 190

  function build() {
    if (els) return
    els = days.map(function (d, i) {
      var a = document.createElement('a')
      a.className = 'cf-item'
      a.href = d.href
      a.dataset.i = i
      var img = document.createElement('img')
      img.alt = ''
      img.decoding = 'async'
      img.draggable = false
      a.appendChild(img)
      stage.appendChild(a)
      return a
    })
    rangeEl.max = String(days.length - 1)
  }

  /** 墙上离视口中心最近的那一块 → 切到封面流时从这里开始 */
  function indexFromWall() {
    var tiles = wall.querySelectorAll('.tile')
    var mid = window.innerHeight / 2
    var best = 0
    var bestD = Infinity
    for (var i = 0; i < tiles.length; i++) {
      var r = tiles[i].getBoundingClientRect()
      var d = Math.abs(r.top + r.height / 2 - mid)
      if (d < bestD) { bestD = d; best = i }
    }
    return best
  }

  function measure() {
    var w = stage.clientWidth || window.innerWidth
    var h = stage.clientHeight || 420
    // 手机上只露出中心 + 两侧各一张，可以给得更大
    var ratio = w < 640 ? 0.62 : 0.33
    tileSize = Math.round(Math.max(120, Math.min(w * ratio, h * 0.68, 380)))
    spread = Math.round(tileSize * 0.63)
  }

  function fill(img, day) {
    var src = day.full || day.thumb
    var tries = 0
    img.onerror = function () {
      // GitHub Pages 偶发 503：先重试原图（带 cache buster），再退回缩略图
      if (tries++ === 0) {
        setTimeout(function () { img.src = src + (src.indexOf('?') < 0 ? '?' : '&') + 'r=' + Date.now() }, 600)
        return
      }
      img.onerror = null
      if (day.thumb && img.src.indexOf(day.thumb) < 0) img.src = day.thumb
    }
    img.src = src
  }

  function render() {
    measure()
    var lo = Math.max(0, active - R)
    var hi = Math.min(days.length - 1, active + R)

    for (var i = shownLo; i <= shownHi; i++) {
      if (i >= 0 && (i < lo || i > hi)) els[i].classList.remove('is-on', 'is-active')
    }
    for (var j = lo; j <= hi; j++) {
      var el = els[j]
      var d = j - active
      var abs = Math.abs(d)
      var img = el.firstChild
      if (img && !img.getAttribute('src')) fill(img, days[j])
      el.classList.add('is-on')
      el.classList.toggle('is-active', d === 0)
      el.style.width = el.style.height = tileSize + 'px'
      el.style.transform =
        'translate(-50%,-50%)' +
        ' translateX(' + (d * spread) + 'px)' +
        ' translateZ(' + (-abs * 26) + 'px)' +
        ' rotateY(' + (d === 0 ? 0 : d > 0 ? -54 : 54) + 'deg)' +
        ' scale(' + (d === 0 ? 1 : 0.9) + ')'
      el.style.zIndex = String(300 - abs)
      el.style.opacity = String(abs === 0 ? 1 : Math.max(0.06, 0.82 - abs * 0.085))
    }
    shownLo = lo
    shownHi = hi

    var cur = days[active]
    elDate.textContent = cur.date
    elTitle.textContent = cur.title
    elAuthor.textContent = cur.author || '—'
    elOpen.href = cur.href
    rangeEl.value = String(active)
    btnPrev.disabled = active === 0
    btnNext.disabled = active === days.length - 1
  }

  function go(n) {
    n = Math.max(0, Math.min(days.length - 1, n))
    if (n === active) return
    active = n
    render()
  }

  /* ---------- 视图切换 ---------- */
  var current = 'wall'
  var savedScroll = 0
  function setView(v, keepHash) {
    var isFlow = v === 'flow'
    var fromWall = current === 'wall' && !wall.hidden
    if (isFlow) build()
    // 必须在藏起墙之前量，否则所有瓦片的 rect 都是 0
    if (isFlow && fromWall && wall.scrollHeight) {
      active = indexFromWall()
      savedScroll = window.scrollY || document.documentElement.scrollTop || 0
    }
    current = v
    flow.hidden = !isFlow
    wall.hidden = isFlow
    document.documentElement.dataset.view = v
    btnsView.forEach(function (b) { b.setAttribute('aria-pressed', String(b.dataset.view === v)) })
    set('view', v)
    if (isFlow) {
      render()
      try { stage.focus({ preventScroll: true }) } catch (e) {}
    } else if (savedScroll) {
      // 墙回来后再恢复滚动位置（隐藏时文档变矮，位置会被浏览器丢掉）
      requestAnimationFrame(function () { window.scrollTo(0, savedScroll) })
    }
    if (!keepHash) {
      try {
        history.replaceState(null, '', v === 'flow' ? '#coverflow' : location.pathname + location.search)
      } catch (e) {}
    }
  }

  btnsView.forEach(function (b) {
    b.addEventListener('click', function () { setView(b.dataset.view) })
  })

  /* ---------- 密度（沿用墙上的三档） ---------- */
  function syncSize() {
    var v = document.documentElement.dataset.size
    btnsSize.forEach(function (b) { b.setAttribute('aria-pressed', String(b.dataset.size === v)) })
  }
  btnsSize.forEach(function (b) {
    b.addEventListener('click', function () {
      document.documentElement.dataset.size = b.dataset.size
      set('tile', b.dataset.size)
      syncSize()
    })
  })

  /* ---------- 交互 ---------- */
  var wheelAcc = 0
  var wheelAt = 0
  stage.addEventListener('wheel', function (e) {
    e.preventDefault()
    var d = Math.abs(e.deltaX) > Math.abs(e.deltaY) ? e.deltaX : e.deltaY
    wheelAcc += d
    var now = Date.now()
    if (Math.abs(wheelAcc) > 28 && now - wheelAt > 55) {
      go(active + (wheelAcc > 0 ? 1 : -1))
      wheelAcc = 0
      wheelAt = now
    }
  }, { passive: false })

  var downX = null
  var downActive = 0
  var dragged = false
  stage.addEventListener('pointerdown', function (e) {
    if (e.pointerType === 'mouse' && e.button !== 0) return
    downX = e.clientX
    downActive = active
    dragged = false
  })
  stage.addEventListener('pointermove', function (e) {
    if (downX === null) return
    var dx = downX - e.clientX
    if (!dragged && Math.abs(dx) < 8) return
    dragged = true
    stage.classList.add('dragging')
    go(downActive + Math.round(dx / (spread * 0.85)))
  })
  function endDrag() {
    if (downX === null) return
    downX = null
    stage.classList.remove('dragging')
    setTimeout(function () { dragged = false }, 0)
  }
  stage.addEventListener('pointerup', endDrag)
  stage.addEventListener('pointercancel', endDrag)

  stage.addEventListener('click', function (e) {
    var a = e.target.closest && e.target.closest('.cf-item')
    if (!a) return
    if (dragged) { e.preventDefault(); return }
    var i = Number(a.dataset.i)
    if (i !== active) { e.preventDefault(); go(i) }
  })

  document.addEventListener('keydown', function (e) {
    if (current !== 'flow') return
    if (e.key === 'ArrowLeft') { go(active - 1); e.preventDefault() }
    else if (e.key === 'ArrowRight') { go(active + 1); e.preventDefault() }
    else if (e.key === 'Home') { go(0); e.preventDefault() }
    else if (e.key === 'End') { go(days.length - 1); e.preventDefault() }
    else if (e.key === 'Escape') { setView('wall') }
  })

  btnPrev.addEventListener('click', function () { go(active - 1) })
  btnNext.addEventListener('click', function () { go(active + 1) })
  btnRand.addEventListener('click', function () { go(Math.floor(Math.random() * days.length)) })
  rangeEl.addEventListener('input', function () { go(Number(rangeEl.value)) })

  var rt = null
  window.addEventListener('resize', function () {
    clearTimeout(rt)
    rt = setTimeout(function () { if (current === 'flow') render() }, 120)
  })

  /* ---------- 初始化 ---------- */
  var savedSize = get('tile')
  if (savedSize) document.documentElement.dataset.size = savedSize
  syncSize()

  var wantFlow = location.hash === '#coverflow' || (!location.hash && get('view') === 'flow')
  setView(wantFlow ? 'flow' : 'wall', true)
})()
