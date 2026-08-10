package com.astrea.core;

public class NaveExploracion extends NaveEspacial implements Propulsable, Defendible {
    private double integridadEscudo;
    private boolean hiperviajeListo;

    public NaveExploracion(String matricula, String modelo, double combustibleInicial, double capacidadCombustible) throws AstreaException {
        super(matricula, modelo, combustibleInicial, capacidadCombustible);
        this.integridadEscudo = 100.0;
        this.hiperviajeListo = true;
    }

    @Override
    public void viajar(double distanciaAniosLuz) throws CombustibleInsuficienteException, AstreaException {
        if (distanciaAniosLuz <= 0) {
            throw new AstreaException("La distancia debe ser positiva.");
        }
        double consumoTotal = distanciaAniosLuz * 0.8;

        if (this.combustible < consumoTotal) {
            throw new CombustibleInsuficienteException("Combustible insuficiente para viaje estándar.");
        }

        this.combustible -= consumoTotal;
    }

    @Override
    public void activarHiperviaje(double factorWarp) throws FallaSistemasException, CombustibleInsuficienteException {
        if (this.combustible < 50.0) {
            throw new CombustibleInsuficienteException("Se requieren al menos 50.0 unidades de combustible para el hiperviaje.");
        }

        if (factorWarp > 9.0) {
            double probabilidad = Math.random();
            if (probabilidad < 0.30) {
                this.hiperviajeListo = false;
                throw new FallaSistemasException("Fallo en el núcleo de salto FTL por Warp extremo.");
            }
        }

        this.combustible -= 50.0;
    }

    @Override
    public void recibirImpacto(double potenciaDano) throws EscudoCriticoException {
        if (this.integridadEscudo <= 0) {
            throw new EscudoCriticoException("Incapaz de operar: Los escudos están inhabilitados.");
        }

        this.integridadEscudo -= potenciaDano;

        if (this.integridadEscudo <= 0.0) {
            this.integridadEscudo = 0.0;
            throw new EscudoCriticoException("¡Alerta crítica! Integridad de escudo destruida.");
        }
    }

    public double getIntegridadEscudo() { return integridadEscudo; }
    public boolean isHiperviajeListo() { return hiperviajeListo; }
}