package com.mycompany.app;

import static org.junit.Assert.assertTrue;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.Test;

import java.util.List;

/**
 * Unit test for simple App.
 */
public class AppTest 
{
    /**
     * Rigorous Test :-)::
     */

    private static final String AWS_REGION = System.getProperty("awsRegion","XYZ");
    @Test
    public void shouldAnswerWithTrue() {
        System.out.println(System.getProperty("auth0Secret"));
        System.out.println(AWS_REGION);
        assertTrue( true );
    }
}
