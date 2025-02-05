import 'dart:math';
import 'package:flutter/material.dart';

class EquipmentCalculatorScreen extends StatefulWidget {
  const EquipmentCalculatorScreen({super.key});

  @override
  _EquipmentCalculatorScreenState createState() =>
      _EquipmentCalculatorScreenState();
}

class _EquipmentCalculatorScreenState extends State<EquipmentCalculatorScreen> {
  final List<EquipmentData> equipmentList = [
    EquipmentData("Шліфувальний верстат", "0.92", "0.9", "0.38", "4", "20",
        "0.15", "1.33"),
    EquipmentData(
        "Свердлильний верстат", "0.92", "0.9", "0.38", "2", "14", "0.12", "1"),
    EquipmentData("Фугувальний верстат", "0.92", "0.9", "0.38", "4", "42",
        "0.15", "1.33"),
    EquipmentData(
        "Циркулярна пила", "0.92", "0.9", "0.38", "1", "36", "0.3", "1.52"),
    EquipmentData("Прес", "0.92", "0.9", "0.38", "1", "20", "0.5", "0.75"),
    EquipmentData(
        "Полірувальний верстат", "0.92", "0.9", "0.38", "1", "40", "0.2", "1"),
    EquipmentData(
        "Фрезерний верстат", "0.92", "0.9", "0.38", "2", "32", "0.2", "1"),
    EquipmentData(
        "Вентилятор", "0.92", "0.9", "0.38", "1", "20", "0.65", "0.75"),
  ];

  String kr = "1.25";
  String kr2 = "0.7";

  String kvGroup = "";
  String effEpAmount = "";
  String totalDepartmentUtilCoef = "";
  String effEpDepartmentAmount = "";
  String rozrahActNav = "";
  String rozrahReactNav = "";
  String fullPower = "";
  String rozrahGroupStrumShr1 = "";
  String rozrahActNavShin = "";
  String rozrahReactNavShin = "";
  String fullPowerShin = "";
  String rozrahGroupStrumShin = "";

  void calculate() {
    double sumOfNPnKvProduct = 0.0;
    double sumOfNPnProduct = 0.0;
    double sumOfNPnPnProduct = 0.0;

    for (var equipment in equipmentList) {
      double quantity = double.tryParse(equipment.quantity.text) ?? 0.0;
      double nominalPower = double.tryParse(equipment.nominalPower.text) ?? 0.0;
      double usageFactor = double.tryParse(equipment.usageFactor.text) ?? 0.0;
      double loadVoltage = double.tryParse(equipment.loadVoltage.text) ?? 1.0;
      double loadPowerFactor =
          double.tryParse(equipment.loadPowerFactor.text) ?? 1.0;
      double efficiencyRating =
          double.tryParse(equipment.efficiencyRating.text) ?? 1.0;

      double multipliedPower = quantity * nominalPower;
      equipment.multipliedPower.text = multipliedPower.toStringAsFixed(2);

      double current = multipliedPower /
          (sqrt(3) * loadVoltage * loadPowerFactor * efficiencyRating);
      equipment.current.text = current.toStringAsFixed(2);

      sumOfNPnKvProduct += multipliedPower * usageFactor;
      sumOfNPnProduct += multipliedPower;
      sumOfNPnPnProduct += quantity * nominalPower * nominalPower;
    }

    double groupUtilCoefficient = sumOfNPnKvProduct / sumOfNPnProduct;
    double effectiveEpAmount =
        (sumOfNPnProduct * sumOfNPnProduct) / sumOfNPnPnProduct;

    double krValue = double.tryParse(kr) ?? 1.0;
    double ph = 27.0;
    double tanPhi = 1.63;
    double un = 0.28;

    double pp = krValue * sumOfNPnKvProduct;
    double qp = groupUtilCoefficient * ph * tanPhi;
    double sp = sqrt((pp * pp) + (qp * qp));
    double ip = pp / un;

    double kvDepartment = 752.0 / 2330.0;
    double nE = (2330.0 * 2330.0) / 96399.0;

    double kvValue = double.tryParse(kr2) ?? 1.0;
    double ppShin = kvValue * 752.0;
    double qpShin = kvValue * 657.0;
    double spShin = sqrt((ppShin * ppShin) + (qpShin * qpShin));
    double ipShin = ppShin / 0.38;

    setState(() {
      kvGroup = groupUtilCoefficient.toStringAsFixed(4);
      effEpAmount = effectiveEpAmount.toStringAsFixed(2);
      totalDepartmentUtilCoef = kvDepartment.toStringAsFixed(4);
      effEpDepartmentAmount = nE.toStringAsFixed(2);
      rozrahActNav = pp.toStringAsFixed(2);
      rozrahReactNav = qp.toStringAsFixed(2);
      fullPower = sp.toStringAsFixed(2);
      rozrahGroupStrumShr1 = ip.toStringAsFixed(2);
      rozrahActNavShin = ppShin.toStringAsFixed(2);
      rozrahReactNavShin = qpShin.toStringAsFixed(2);
      fullPowerShin = spShin.toStringAsFixed(2);
      rozrahGroupStrumShin = ipShin.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Калькулятор обладнання")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (var equipment in equipmentList) _equipmentForm(equipment),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: calculate, child: const Text("Обчислити")),
            const SizedBox(height: 16),
            _resultText("Груповий коефіцієнт використання", kvGroup),
            _resultText("Ефективна кількість ЕП", effEpAmount),
            _resultText("Розрахункове активне навантаження", rozrahActNav),
            _resultText("Розрахункове реактивне навантаження", rozrahReactNav),
            _resultText("Повна потужність", fullPower),
            _resultText(
                "Розрахунковий груповий струм ШР1", rozrahGroupStrumShr1),
            _resultText("Коефіцієнт використання цеху в цілому",
                totalDepartmentUtilCoef),
            _resultText(
                "Ефективна кількість ЕП цеху в цілому", effEpDepartmentAmount),
            _resultText(
                "Розрахункове активне навантаження на шинах", rozrahActNavShin),
            _resultText("Розрахункове реактивне навантаження на шинах",
                rozrahReactNavShin),
            _resultText("Повна потужність на шинах", fullPowerShin),
            _resultText(
                "Розрахунковий груповий струм на шинах", rozrahGroupStrumShin),
          ],
        ),
      ),
    );
  }

  Widget _equipmentForm(EquipmentData equipment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Назва обладнання: ${equipment.equipmentName}",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        _inputField("ККД обладнання", equipment.efficiencyRating),
        _inputField("Коефіцієнт потужності", equipment.loadPowerFactor),
        _inputField("Напруга (кВ)", equipment.loadVoltage),
        _inputField("Кількість", equipment.quantity),
        _inputField("Номінальна потужність (кВт)", equipment.nominalPower),
        _inputField("Коефіцієнт використання", equipment.usageFactor),
        _inputField("tgφ", equipment.reactivePowerCoefficient),
        const Divider(),
      ],
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
    );
  }

  Widget _resultText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
    );
  }
}

class EquipmentData {
  final String equipmentName;
  final TextEditingController efficiencyRating,
      loadPowerFactor,
      loadVoltage,
      quantity,
      nominalPower,
      usageFactor,
      reactivePowerCoefficient,
      multipliedPower,
      current;

  EquipmentData(this.equipmentName, String eff, String lp, String lv, String q,
      String np, String uf, String rpc)
      : efficiencyRating = TextEditingController(text: eff),
        loadPowerFactor = TextEditingController(text: lp),
        loadVoltage = TextEditingController(text: lv),
        quantity = TextEditingController(text: q),
        nominalPower = TextEditingController(text: np),
        usageFactor = TextEditingController(text: uf),
        reactivePowerCoefficient = TextEditingController(text: rpc),
        multipliedPower = TextEditingController(),
        current = TextEditingController();
}
