// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract Estudiante{

    string private _nombre;
    string private _apellido;
    string private _curso;
    address private _docente;
    mapping(string => uint) private _notas;

    uint private _suma_notas = 0;
    uint private _cant_notas = 0;

    constructor(string memory nombre_, string memory apellido_, string memory curso_){
        _nombre = nombre_;
        _apellido = apellido_;
        _curso = curso_;
        _docente = msg.sender;
    }

    modifier solo_docente() {
        require(msg.sender == _docente, "Solo el docente puede realizar esta accion");
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

    function set_nota_materia(string memory materia_, uint nota_) public solo_docente{
        if (_notas[materia_] > 0)
        {
            _suma_notas -= _notas[materia_];
        }
        else 
        {
            _cant_notas++;
        }
        _suma_notas += nota_;
        _notas[materia_] = nota_;
    }

    function nota_materia(string memory materia_) public view returns (uint){
        require(_notas[materia_] > 0, "La materia requisitada no existe o no tiene nota asignada");
        return _notas[materia_];
    }

    function aprobo(string memory materia_) public view returns (bool){
        require(_notas[materia_] > 0, "La materia requisitada no existe o no tiene nota asignada");
        if (_notas[materia_] > 59)
        {
            return true;
        }
        return false;
    }

    function promedio() public view returns (uint){
        require( _cant_notas > 0, "Ningua nota ha sido ingresada aun");
        return _suma_notas / _cant_notas;
    }
}