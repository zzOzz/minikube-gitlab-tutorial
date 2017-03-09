package fr.udl.sample;

/**
 * Hello world!
 *
 */
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;
 import javax.servlet.ServletException;
 import java.io.IOException;
 import org.eclipse.jetty.server.Server;
 import org.eclipse.jetty.server.Request;
 import org.eclipse.jetty.server.handler.AbstractHandler;

 public class HelloWorld extends AbstractHandler
 {
     public void handle(String target,
                        Request baseRequest,
                        HttpServletRequest request,
                        HttpServletResponse response)
         throws IOException, ServletException
     {
         response.setContentType("text/html;charset=utf-8");
         response.setStatus(HttpServletResponse.SC_OK);
         baseRequest.setHandled(true);
         response.getWriter().println("<html><script>setTimeout(function(){window.location.reload(1);}, 1000);</script><h1>Hello World</h1>" + this.getClass().getPackage().getImplementationVersion() + "</html>");
     }

     public static void main(String[] args) throws Exception
     {
         Server server = new Server(8080);
         server.setHandler(new HelloWorld());
         server.start();
         server.join();
     }
 }
