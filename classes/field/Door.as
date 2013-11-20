package field {
	import field.FieldObject;
	
	public class Door extends FieldObject {
		public var exit:Door;
		public function Door(ix:uint=0, jx:uint=0) {
			super(FieldObject.DOOR, ix, jx, false);
			exit = null;
		}
	}
}