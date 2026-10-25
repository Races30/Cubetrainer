package com.example.cubetrainer

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import android.graphics.BitmapFactory
import android.view.View

class StatsWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.stats_widget_small).apply {
                
                val bestTime = widgetData.getString("best_time", "--")
                val ao5 = widgetData.getString("ao5", "--")
                val cubeType = widgetData.getString("cube_type", "3x3")

                setTextViewText(R.id.best_time_text, bestTime)
                setTextViewText(R.id.ao5_text, ao5)
                setTextViewText(R.id.cube_type_text, cubeType)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}

class StatsWidgetMediumProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.stats_widget_medium).apply {
                
                val bestTime = widgetData.getString("best_time", "--")
                val ao5 = widgetData.getString("ao5", "--")
                val ao12 = widgetData.getString("ao12", "--")
                val solveCount = widgetData.getInt("solve_count", 0).toString()
                val cubeType = widgetData.getString("cube_type", "3x3")
                val sparklinePath = widgetData.getString("sparkline_path", "")

                setTextViewText(R.id.best_time_text, bestTime)
                setTextViewText(R.id.ao5_text, ao5)
                setTextViewText(R.id.ao12_text, ao12)
                setTextViewText(R.id.solve_count_text, "Solves: $solveCount")
                setTextViewText(R.id.cube_type_text, cubeType)

                if (sparklinePath != null && sparklinePath.isNotEmpty()) {
                    val bitmap = BitmapFactory.decodeFile(sparklinePath)
                    if (bitmap != null) {
                        setImageViewBitmap(R.id.sparkline_image, bitmap)
                        setViewVisibility(R.id.sparkline_image, View.VISIBLE)
                    } else {
                        setViewVisibility(R.id.sparkline_image, View.GONE)
                    }
                } else {
                    setViewVisibility(R.id.sparkline_image, View.GONE)
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
