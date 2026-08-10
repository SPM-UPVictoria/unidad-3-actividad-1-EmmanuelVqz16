package com.astrea.core;

import org.junit.Test;
import static org.junit.Assert.*;

public class NaveTest {

    @Test
    public void testCreacionYRepostajeValido() throws AstreaException {
        NaveCarga nave = new NaveCarga("NC-01", "Titan", 100.0, 200.0, 500.0);
        nave.repostarCombustible(50.0);
        assertEquals(150.0, nave.getCombustible(), 0.001);
    }

    @Test
    public void testViajeCargaNormal() throws AstreaException {
        NaveCarga nave = new NaveCarga("NC-01", "Titan", 100.0, 200.0, 500.0);
        nave.viajar(10.0);
        assertEquals(85.0, nave.getCombustible(), 0.001);
    }

    @Test
    public void testViajeExploracionNormal() throws AstreaException {
        NaveExploracion nave = new NaveExploracion("NX-01", "Voyager", 100.0, 200.0);
        nave.viajar(10.0);
        assertEquals(92.0, nave.getCombustible(), 0.001);
    }

    @Test
    public void testHiperviajeExitoso() throws AstreaException {
        NaveExploracion nave = new NaveExploracion("NX-01", "Voyager", 100.0, 200.0);
        nave.activarHiperviaje(5.0);
        assertEquals(50.0, nave.getCombustible(), 0.001);
    }

    @Test
    public void testCargaSobrecargadaConsumoDoble() throws AstreaException {
        NaveCarga nave = new NaveCarga("NC-01", "Titan", 100.0, 200.0, 500.0);
        nave.cargar(300.0);
        nave.viajar(10.0);
        assertEquals(70.0, nave.getCombustible(), 0.001);
    }

    @Test
    public void testRecibirDanoEscudoNormal() throws AstreaException {
        NaveExploracion nave = new NaveExploracion("NX-01", "Voyager", 100.0, 200.0);
        nave.recibirImpacto(40.0);
        assertEquals(60.0, nave.getIntegridadEscudo(), 0.001);
    }

    @Test(expected = CombustibleInsuficienteException.class)
    public void testViajeSinCombustibleAtomicidad() throws AstreaException {
        NaveCarga nave = new NaveCarga("NC-01", "Titan", 20.0, 200.0, 500.0);
        try {
            nave.viajar(50.0);
        } catch (CombustibleInsuficienteException e) {
            assertEquals(20.0, nave.getCombustible(), 0.001);
            throw e;
        }
    }

    @Test(expected = AstreaException.class)
    public void testRepostajeExcedeCapacidad() throws AstreaException {
        NaveCarga nave = new NaveCarga("NC-01", "Titan", 180.0, 200.0, 500.0);
        nave.repostarCombustible(50.0);
    }

    @Test(expected = EscudoCriticoException.class)
    public void testEscudoCriticoException() throws AstreaException {
        NaveExploracion nave = new NaveExploracion("NX-01", "Voyager", 100.0, 200.0);
        nave.recibirImpacto(120.0);
    }

    @Test(expected = AstreaException.class)
    public void testCreacionNaveInvalida() throws AstreaException {
        new NaveCarga("NC-01", "Titan", 300.0, 200.0, 500.0);
    }
}