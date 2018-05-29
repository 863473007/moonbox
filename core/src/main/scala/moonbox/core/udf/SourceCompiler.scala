package moonbox.core.udf

import javax.tools._
import scala.collection.JavaConversions._
object SourceCompiler {

	def compileScala(src: String): Class[_] = {
		import scala.reflect.runtime.universe
		import scala.tools.reflect.ToolBox
		val classLoader = scala.reflect.runtime.universe.getClass.getClassLoader
		val tb = universe.runtimeMirror(classLoader).mkToolBox()
		val tree = tb.parse(src)
		val clazz = tb.compile(tree).apply().asInstanceOf[Class[_]]
		clazz
	}

	def prepareScala(src: String, className: String): String = {
		s"""$src
		   |scala.reflect.classTag[$className].runtimeClass
		 """.stripMargin
	}

	def compileJava(src: String, className: String): Class[_] = {
		val compiler = ToolProvider.getSystemJavaCompiler
		val diagnostics: DiagnosticCollector[JavaFileObject] = new DiagnosticCollector[JavaFileObject]
		val byteObject: JavaByteObject = new JavaByteObject(className)
		val standardFileManager: StandardJavaFileManager = compiler.getStandardFileManager(diagnostics, null, null)
		val fileManager: JavaFileManager = JavaReflect.createFileManager(standardFileManager, byteObject)
		val task = compiler.getTask(null, fileManager, diagnostics, null, null, JavaReflect.getCompilationUnits(className, src))
		if (!task.call()) {
			diagnostics.getDiagnostics.foreach(println)
		}
		fileManager.close()
		val inMemoryClassLoader = JavaReflect.createClassLoader(byteObject)
		val clazz = inMemoryClassLoader.loadClass(className)
		clazz
	}

}
