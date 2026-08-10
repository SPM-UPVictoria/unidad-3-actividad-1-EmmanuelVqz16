package com.astrea.core;

public class NaveCarga extends NaveEspacial {
    private double cargaActual;
    private double cargaMaxima;

    public NaveCarga(String matricula, String modelo, double combustibleInicial, double capacidadCombustible, double cargaMaxima) throws AstreaException {
        super(matricula, modelo, combustibleInicial, capacidadCombustible);
        if (cargaMaxima <= 0) {
            throw new AstreaException("La carga máxima debe ser estrictamente positiva.");
        }
        this.cargaMaxima = cargaMaxima;
        this.cargaActual = 0.0;
    }

    public void cargar(double peso) throws AstreaException {
        if (peso <= 0 || this.cargaActual + peso > cargaMaxima) {
            throw new AstreaException("Carga inválida o excede el límite máximo.");
        }
        this.cargaActual += peso;
    }

    @Override
    public void viajar(double distanciaAniosLuz) throws CombustibleInsuficienteException, AstreaException {
        if (distanciaAniosLuz <= 0) {
            throw new AstreaException("La distancia debe ser positiva.");
        }
        
        double consumoPorAnioLuz = (cargaActual > cargaMaxima * 0.5) ? 3.0 : 1.5;
        double consumoTotal = distanciaAniosLuz * consumoPorAnioLuz;

        if (this.combustible < consumoTotal) {
            throw new CombustibleInsuficienteException("Combustible insuficiente para realizar el viaje.");
        }

        this.combustible -= consumoTotal;
    }

    public double getCargaActual() { return cargaActual; }
    public double getCargaMaxima() { return cargaMaxima; }
}