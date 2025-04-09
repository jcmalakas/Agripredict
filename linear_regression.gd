extends Control
#@onready var chart:Chart = $VBoxContainer/Chart
@onready var chart:Chart = $PanelContainer/MarginContainer/PanelContainer/MarginContainer2/HBoxContainer/Chart

@onready var currentlyPlanted:Label = $PanelContainer/MarginContainer/PanelContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Datas/currentlyPlanted
@onready var lossProfit:Label = $PanelContainer/MarginContainer/PanelContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Datas/lossProfit
@onready var rainfalls:Label = $PanelContainer/MarginContainer/PanelContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Datas/rainfalls
@onready var cropLoss:Label =  $PanelContainer/MarginContainer/PanelContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Datas/cropLoss
@onready var profits:Label = $PanelContainer/MarginContainer/PanelContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Datas/profits
@onready var totalPredictedProfit: Label = $PanelContainer/MarginContainer/PanelContainer/MarginContainer2/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Datas/total

#this is the Y values
	#var tips: Array = [5, 17, 11, 8, 14, 5]
#var cropLosses : Array = [5, 17, 11, 8, 14, 5]
var cropLosses : Array = WeeklyReport.cropLosses

#this is the X values
	#var bills : Array = [34, 108, 64, 88, 99, 51]
#var rainChances: Array = [34, 108, 64, 88, 99, 51]
var rainChances: Array = WeeklyReport.rainStrenghts

var scatterPlot : Function
var regressionLine: Function

signal donePressedLR

func _process(delta: float) -> void:
	currentlyPlanted.text = str(WeeklyReport.currentlyPlanted) 
	
	#debug this so it only detects if it only rains
	rainfalls.text = str(WeeklyReport.rainCount)
	
	var total = 0
	for num in WeeklyReport.cropLosses:
		total += num
	cropLoss.text = str(total) 
	
	var losses = total * WeeklyReport.profitPerHarvest
	lossProfit.text = str(losses)
	
	var totalProfit = ((WeeklyReport.currentlyPlanted + InventoryManager.inventory["wheat"]) * WeeklyReport.profitPerHarvest) + InventoryManager.money
	profits.text = str(totalProfit)
	
	var currentlyPlantedProfit = WeeklyReport.currentlyPlanted * WeeklyReport.profitPerHarvest
	totalPredictedProfit.text = str((currentlyPlantedProfit + InventoryManager.totalMoney) - (losses + WeeklyReport.debt))

func _ready() -> void:
	
#region Initializing the chart Properties
	#initialize the chart
	var cp: ChartProperties = ChartProperties.new()
	#cp.colors.frame = Color.from_rgba8(22, 26, 29, 245)
	cp.colors.frame = Color.TRANSPARENT
	cp.colors.background = Color.TRANSPARENT
	#cp.colors.grid = Color("#283442")
	#cp.colors.grid = Color("#283442")
	cp.colors.grid = Color("754c60")
	cp.colors.ticks = Color("#b68962")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.title = "Linear Regression"
	cp.x_label = "Rain Strenght (%)"
	cp.y_label = "Crop Loss"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
#endregion

#region ScatterPlotProperties
	scatterPlot = Function.new(
		rainChances, cropLosses, "", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		# Let's also provide a dictionary of configuration parameters for this specific function.
		{ 
			color = Color("e8cfa6"), 		# The color associated to this function
			marker = Function.Marker.CIRCLE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.SCATTER, 		# This defines what kind of plotting will be used, 
											# in this case it will be a Linear Chart.
		}
	)
	
#endregion
	
#region Table Data
	#Taking the data in the table, Reference: https://youtu.be/Qa2APhWjQPc?t=1159
	#godot has no built in function on getting the mean so I create one
	var billsMeans:float = calculate_mean(rainChances)
	var billsDeviation : Array
	for x in rainChances:
		billsDeviation.append(x - billsMeans)
		pass
	print("This is the bill ", rainChances)
	print("This is the bill mean ", billsMeans)
	print("This is the bill deviation ", billsDeviation)
	
	var tipsMeans:float = calculate_mean(cropLosses)
	var tipsDeviation : Array
	for y in cropLosses:
		tipsDeviation.append(y - tipsMeans)
		pass
	print("This is the tips ", cropLosses)
	print("This is the tips mean ", tipsMeans)
	print("This is the tips deviation ", tipsDeviation)
	
	var deviationProducts:Array = multiply_arrays(billsDeviation, tipsDeviation)
	var sumDeviationProducts:float = sum_array(deviationProducts)
	print("This is the deviationProducts ", deviationProducts)
	
	var billsDeviationSquare: Array = square_array_elements(billsDeviation)
	var sumbillsDeviationSquare:float = sum_array(billsDeviationSquare)
	print("This is the billsDeviationSquare ", billsDeviationSquare)
	
#endregion
	
	
	var b1:float = sumDeviationProducts/sumbillsDeviationSquare
	var b0:float = tipsMeans - (b1*billsMeans)
	
	print(b1)
	print(b0)
	
	var regressionLineY : Array
	var regressionLineX : Array
	#I added 50 in the original so the line looks longer
		#var graphLenghtX = cropLosses.max() + 50
	var graphLenghtX = rainChances.max() + 40
	
	
	for x in range(0, 110, 20):
		#b1 = slope, b0 = intercept, x is given
		#y = b1x - b0
		var y = (b1 * x) - abs(b0)
		regressionLineY.append(y)
		regressionLineX.append(x)
	
	regressionLine = Function.new(
		regressionLineX, regressionLineY, "Line", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		# Let's also provide a dictionary of configuration parameters for this specific function.
		{ 
			#color = Color("#e8cfa6")
			color = Color("#aa7959"), 		# The color associated to this function
			marker = Function.Marker.NONE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE,
			interpolation = Function.Interpolation.LINEAR
		}
	)

	
	chart.plot([scatterPlot, regressionLine], cp)
	
	print("rain Chances" + str(cropLosses))
	print("crop Losses" + str(rainChances))
	#print(regressionLineX)
	#print(regressionLineY)


func _on_button_pressed() -> void:
	##Add the point to the function scatterPlot
	#var xValueBox:int = ($VBoxContainer/HBoxContainer/x.text).to_int()
	#var yValueBox:int = ($VBoxContainer/HBoxContainer/y.text).to_int()
	#scatterPlot.add_point(xValueBox,yValueBox)
	#
	##this updates the chart
	#chart.queue_redraw()
	#pass # Replace with function body.
	#WeeklyReport.done = true
	
	#get_tree().paused = false
	#WeeklyReport.weeklyReportInstantiated = false
	#WeeklyReport.rainCount = 0
	
	#WeeklyReport.shown = true
	WeeklyReport.dataFinalized = false
	get_tree().paused = false
	get_parent().queue_free()
	


#region math functions that is not built in godot
func calculate_mean(array):
	var sum = 0.0
	for value in array:
		sum += value
	var mean = sum / array.size()
	return mean
	
func multiply_arrays(array1, array2):
	if array1.size() != array2.size():
		print("Error: Arrays must be of the same size.")
		return null

	var result = []
	for i in range(array1.size()):
		result.append(array1[i] * array2[i])
	return result
	
func square_array_elements(array):
	var squared_array = []
	for element in array:
		squared_array.append(element * element)
	return squared_array


func sum_array(array):
	var sum = 0.0
	for element in array:
		sum += element
	return sum
#endregion
