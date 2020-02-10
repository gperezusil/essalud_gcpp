import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class Metodos{
 
 var redes = ['ALMENARA','AMAZONAS','ANCASH','APURIMAC','AREQUIPA','AYACUCHO','CAJAMARCA','CUSCO','HUANCAVELICA','HUANUCO',
'HUARAZ','I.N.CARDIOVASCULAR','ICA','JULIACA','JUNIN','LA LIBERTAD','LAMBAYEQUE','LORETO','MADRE DE DIOS','MOQUEGUA','MOYOBAMBA',
'PASCO','PIURA','PUNO','REBAGLIATI','SABOGAL','SALUD RENAL','TACNA','TARAPOTO','TOTAL','TUMBES','UCAYALI'];

  var gerencia=['CD-CONSEJO DIRECTIVO','CEABE - CENTRAL DE ABASTECIMIENTO DE BIENES ESTRATEGICO','CENATE - CENTRO NACIONAL DE TELEMEDICINA',
'CONTG - CONTINGENCIAS','GCAA - GERENCIA CENTRAL DE ATENCIÓN AL ASEGURADO','GCAJ - GERENCIA CENTRAL DE ASESORIA JURIDICA',
'GCGF - GERENCIA CENTRAL DE GESTION FINANCIERA','GCGP - GERENCIA CENTRAL DE GESTION DE LAS PERSONAS','GCL - GERENCIA CENTRAL DE LOGISTICA',
'GCO - GERENCIA CENTRAL DE OPERACIONES','GCPAM - GERENCIA CENTRAL DE LA PERS. ADULTA MAYOR Y PERS CON DISCAP.','GCPGCI - GERENCIA CENTRAL DE PROM. Y GES. DE CONTRATOS DE INVERS.',
'GCPI - GERENCIA CENTRAL DE PROYECTOS DE INVERSION','GCPP - GERENCIA CENTRAL DE PLANEAMIENTO Y PRESUPUESTO','GCPS - GERENCIA CENTRAL DE PRESTACIONES DE SALUD',
'GCSPE - GERENCIA CENTRAL DE SEGUROS Y PRESTACIONES ECONOMICAS','GCTIC - GERENCIA CENTRAL DE TEC. DE LA INFORMAC. Y COMUNIC.','GG - GERENCIA GENERAL',
'GOF - GERENCIA DE OFERTA FLEXIBLE','IETSI - INSTITUTO DE EVALUACION DE TECN. EN SALUD E INVESTIGACION',
'OCI - ORGANO DE CONTROL INSTITUCIONAL','ODN - OFICINA DE DEFENSA NACIONAL',
'OFCI - OFICINA DE COOPERACION INTERNACIONAL','OFIN - OFICINA DE INTEGRIDAD','OGC - OFICINA DE GESTION DE LA CALIDAD',
'ORI - OFICINA DE RELACIONES INSTITUCIONALES','PE - PRESIDENCIA EJECUTIVA','SG - SECRETARIA GENERAL','TOTAL'
];
  num verificarNumero(num numero) {
    if (1 - numero < 0) {
      return 0.99;
    } else if(numero<0) {
      return 0.0001;
    }else{
      return numero;
    }
  }

    FlutterMoneyFormatter formatearNumero(double variable) {
    return FlutterMoneyFormatter(amount: variable.toDouble());
  }

 String mayuscula(String s){
    return  s[0].toUpperCase() + s.substring(1);
  }
}