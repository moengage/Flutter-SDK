package com.moengage.flutter.internal.tooltip

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView

/**
 * A small speech-bubble tooltip: a rounded-rect message bubble with a triangular arrow
 * pointing up towards its anchor. Shared by [NativeTooltipRenderer] (added directly to the
 * window) and [MoeTooltipPlatformView] (embedded in the Flutter widget tree as a
 * `PlatformView`), so both rendering paths look identical.
 */
internal class TooltipBubbleView(context: Context, message: String) : LinearLayout(context) {
    companion object {
        private const val BUBBLE_COLOR = "#DD2962FF"
        private const val ARROW_WIDTH_DP = 16f
        private const val ARROW_HEIGHT_DP = 8f
    }

    init {
        orientation = VERTICAL
        val density = resources.displayMetrics.density
        val paddingH = (16 * density).toInt()
        val paddingV = (10 * density).toInt()

        addView(
            TooltipArrowView(context),
            LayoutParams(
                (ARROW_WIDTH_DP * density).toInt(),
                (ARROW_HEIGHT_DP * density).toInt(),
            ).apply { gravity = Gravity.CENTER_HORIZONTAL },
        )

        val background =
            GradientDrawable().apply {
                shape = GradientDrawable.RECTANGLE
                cornerRadius = 12 * density
                setColor(Color.parseColor(BUBBLE_COLOR))
            }
        addView(
            TextView(context).apply {
                text = message
                setTextColor(Color.WHITE)
                textSize = 14f
                setPadding(paddingH, paddingV, paddingH, paddingV)
                this.background = background
                elevation = 8 * density
            },
            LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT),
        )
    }

    /** Small upward-pointing triangle drawn in the same colour as the bubble. */
    private class TooltipArrowView(context: Context) : View(context) {
        private val paint =
            Paint(Paint.ANTI_ALIAS_FLAG).apply {
                color = Color.parseColor(BUBBLE_COLOR)
                style = Paint.Style.FILL
            }
        private val path = Path()

        override fun onSizeChanged(
            w: Int,
            h: Int,
            oldw: Int,
            oldh: Int,
        ) {
            super.onSizeChanged(w, h, oldw, oldh)
            path.reset()
            path.moveTo(w / 2f, 0f)
            path.lineTo(w.toFloat(), h.toFloat())
            path.lineTo(0f, h.toFloat())
            path.close()
        }

        override fun onDraw(canvas: Canvas) {
            super.onDraw(canvas)
            canvas.drawPath(path, paint)
        }
    }
}
