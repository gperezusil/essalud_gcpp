class Datos {
  String _titulo;
  num _pia;
  num _ejecucion;
  num _porcentaje;
  String _padre;

  Datos(
      this._titulo, this._pia, this._ejecucion, this._porcentaje, this._padre);

  Datos.map(dynamic obj) {
    this._titulo = obj['titulo'];
    this._pia = obj['pia'];
    this._ejecucion = obj['ejecucion'];
    this._porcentaje = obj['porcentaje'];
    this._padre = obj['padre'];
  }
  String get titulo => _titulo;
  num get pia => _pia;
  num get ejecucion => _ejecucion;
  num get porcentaje => _porcentaje;
  String get padre => _padre;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['titulo'] = _titulo;
    map['pia'] = _pia;
    map['ejecucion'] = _ejecucion;
    map['porcentaje'] = _porcentaje;
    map['padre'] = _padre;

    return map;
  }

  Datos.fromMap(Map<String, dynamic> map) {
    this._titulo = map['titulo'];
    this._pia = map['pia'];
    this._ejecucion = map['ejecucion'];
    this._porcentaje = map['porcentaje'];
    this._padre = map['padre'];
  }
}
