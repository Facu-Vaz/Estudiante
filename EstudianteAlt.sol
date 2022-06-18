// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Estudiante{

    string private _nombre;
    string private _apellido;
    string private _curso;
    mapping(uint => mapping(string => uint)) private _notas;
    mapping(address => bool) private _es_maestro;

    uint[] private _suma_notas = [0, 0, 0, 0];
    uint[] private _cant_notas = [0, 0, 0, 0];

    

    constructor(string memory nombre_, string memory apellido_, string memory curso_){
        _nombre = nombre_;
        _apellido = apellido_;
        _curso = curso_;
        _es_maestro[msg.sender] = true;
    }

    event nota_asignada(uint nota, string materia, uint bim);

    modifier solo_docente() {
        require(_es_maestro[msg.sender], "Solo el docente puede realizar esta accion");
        _;
    }

    function apellido() public view returns (string memory){
        return _apellido;
    }

    function nombre_completo() public view returns (string memory){
        return string(abi.encodePacked(_nombre," ",_apellido));
    }

    function curso() public view returns (string memory){
        return _curso;
    }

    function set_nota_materia(string memory materia_, uint nota_, uint bimestre_) public solo_docente{
        if (_notas[bimestre_][materia_] > 0)
        {
            _suma_notas[bimestre_] -= _notas[bimestre_][materia_];
            emit nota_asignada(nota_, materia_, bimestre_);
        }
        else 
        {
            _cant_notas[bimestre_]++;
        }
        _suma_notas[bimestre_] += nota_;
        _notas[bimestre_][materia_] = nota_;
    }

    function autorizar_docente(address nuevo_docente) public solo_docente{
        _es_maestro[nuevo_docente] = true;
    }

    function nota_materia(string memory materia_, uint bimestre_) public view returns (uint){
        require(_notas[bimestre_][materia_] > 0, "La materia requisitada no existe o no tiene nota asignada");
        return _notas[bimestre_][materia_];
    }

    function aprobo(string memory materia_, uint bimestre_) public view returns (bool){
        require(_notas[bimestre_][materia_] > 0, "La materia requisitada no existe o no tiene nota asignada");
        if (_notas[bimestre_][materia_] > 59)
        {
            return true;
        }
        return false;
    }

    function promedio(uint bimestre_) public view returns (uint){
        require( _cant_notas[bimestre_] > 0, "Ningua nota ha sido ingresada aun en ese bimestre");
        return _suma_notas[bimestre_] / _cant_notas[bimestre_];
    }
}